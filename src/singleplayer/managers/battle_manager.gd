## Owns the whole battle flow of a single level attempt: which round and
## which question is current, how much time is left, who takes damage,
## what loot the round gives and when the attempt is over.
##
## Models stay passive: this manager holds the cursor, decides the rules
## and announces everything via signals, so a presenter can mirror the
## battle into passive views.
class_name BattleManager extends RefCounted


#region constants

## How many questions a player must answer to finish a round
const QUESTIONS_PER_ROUND = 3

## How long the resolved answer stays highlighted before the battle continues
const RESULT_DELAY_SECONDS = 1.5

## Damage dealt to the enemy when the answer is correct
const DEFAULT_CORRECT_ANSWER_DAMAGE = 25

## Damage dealt to the player when the answer is wrong or timed out
const DEFAULT_WRONG_ANSWER_DAMAGE = 25

## Level tier zero has no meaning for battle entities
const MIN_TIER = 1

#endregion


#region signals

signal attempt_started(attempt: LevelAttempt)
signal round_started(index: int, round: Round)
signal round_passed(index: int)
signal question_presented(question: Question, number: int)
signal countdown_ticked(seconds: int)
signal answer_resolved(result: AnswerResult)
signal damage_applied(victim: Character, amount: int)
signal treasure_added(treasure: Treasure)
signal attempt_over(result: LevelResult)

## Wakes the flow up when an answer (real or timeout) became available
signal answer_submitted()

#endregion


#region fields

var _host: Node
var _loot_manager: LootManager
var _session: PlayerSession

var _level: Level
var _attempt: LevelAttempt
var _arena: Arena
var _player_character: Character
var _treasure_bag: TreasureBag

var _round_types: Array[RoundType] = []
var _round_index: int = -1
var _current_round: Round
var _current_enemy: Character

var _question_pool: QuestionPool
var _question_number: int = 0
var _current_question: Question
var _countdown: CountdownTimer

var _answer_index: int = -1
var _answer_reason: AnswerResult.EndReasons = AnswerResult.EndReasons.ANSWERED
var _answer_arrived: bool = false

var _is_round_over: bool = false
var _is_player_dead: bool = false
var _is_attempt_over: bool = false
var _is_cancelled: bool = false

var correct_answer_damage: int = DEFAULT_CORRECT_ANSWER_DAMAGE
var wrong_answer_damage: int = DEFAULT_WRONG_ANSWER_DAMAGE

#endregion


#region builtins

func _init(host: Node, loot_manager: LootManager, session_manager: SessionManager) -> void:
	_host = host
	_loot_manager = loot_manager
	_session = session_manager.session()

#endregion


#region getters/setters

func attempt() -> LevelAttempt:
	return _attempt


func level() -> Level:
	return _level


func round_types() -> Array[RoundType]:
	return _round_types


func current_round_index() -> int:
	return _round_index


func is_attempt_over() -> bool:
	return _is_attempt_over

#endregion


#region public

## Builds the level attempt data: player character, arena, treasure bag
## and the list of rounds. Nothing is shown yet, use `run` for that.
func start(level: Level) -> LevelAttempt:

	_level = level

	var tier = _level_tier()
	var level_info = level.get_info()

	_player_character = Character.of(_session.get_character_type(), tier)

	_arena = Arena.make(level_info.arena_info, _player_character)
	_arena.character_died.connect(_on_character_died)

	_treasure_bag = TreasureBag.new()

	_round_types = _collect_round_types(level_info.round_sequence)

	_attempt = LevelAttempt.new(level, _arena, _treasure_bag, level_info.round_sequence, _player_character)
	attempt_started.emit(_attempt)

	print_debug("Started new level attempt...")
	print_debug(_attempt_start_report(tier))

	return _attempt


## This method is asynchronous.
## Starts the battle flow. Should be called after the presenter
## has connected to the signals and placed the arena into the scene tree.
func run() -> void:
	await _transition_to(IntroState.new(self))


## Called by the presenter when the player chose an answer variant.
## `variant_idx` equal to `-1` means that the answer was not given.
func submit_answer(variant_idx: int) -> void:
	_make_answer_available(variant_idx, AnswerResult.EndReasons.NO_ANSWER if variant_idx < 0 else AnswerResult.EndReasons.ANSWERED)


## Breaks the flow. Called when the presenter leaves the battle screen.
func cancel() -> void:

	if _is_cancelled:
		return

	_is_cancelled = true
	_stop_countdown()
	answer_submitted.emit()

#endregion


#region private

func _level_tier() -> int:
	return max(MIN_TIER, _level.get_tier())


## Builds a full report about the values the attempt has started with.
func _attempt_start_report(tier: int) -> String:

	var report = """\
		Attempt start report:
			level: {level}
			level tier: {tier}
			player character: {player}
			player health: {player_health}/{player_max_health}
			arena: {arena}
			rounds amount: {rounds_amount}
			questions per round: {questions_per_round}
			correct answer damage: {correct_damage}
			wrong answer damage: {wrong_damage}
			result delay: {result_delay}
			treasure bag: gold={gold}, items={items_amount}"""

	return report.format({
		level = _level,
		tier = tier,
		player = _player_character,
		player_health = _player_character.get_health().get_health(),
		player_max_health = _player_character.get_health().get_max_health(),
		arena = _arena,
		rounds_amount = _round_types.size(),
		questions_per_round = QUESTIONS_PER_ROUND,
		correct_damage = correct_answer_damage,
		wrong_damage = wrong_answer_damage,
		result_delay = RESULT_DELAY_SECONDS,
		gold = _treasure_bag.get_total_gold(),
		items_amount = _treasure_bag.get_items().size()
	}) + _rounds_start_report()


## Builds a report about every round planned in the current attempt.
func _rounds_start_report() -> String:

	var report = ""
	for index in _round_types.size():
		report += "\n" + _round_start_report(index)
	return report


## Builds a report about the round with the given `index`
## and all the values it will be started with.
func _round_start_report(index: int) -> String:

	var round_type = _round_types[index]
	var bank = round_type.associated_question_bank

	var report = """\
			Round {index} start report:
				battle type: {battle_type}, is boss: {is_boss}
				round tier: {tier}
				base gold: {base_gold}
				possible enemy types: {enemy_types}
				possible loot types: {loot_types_amount}
				question bank: {bank_name} with {bank_questions_amount} questions
				answers countdown: {countdown}"""

	return report.format({
		index = index,
		battle_type = round_type.battle_type,
		is_boss = round_type.is_boss(),
		tier = _level_tier(),
		base_gold = round_type.base_gold,
		enemy_types = _character_type_names(round_type.possible_enemy_types),
		loot_types_amount = round_type.possible_loot.size(),
		bank_name = bank.name if bank else "<none>",
		bank_questions_amount = bank.question_types.size() if bank else 0,
		countdown = _countdown_seconds_of(bank)
	})


## Builds a report about the round that has just been opened:
## both spawned characters and the question source.
func _opened_round_report() -> String:

	var round_type = _current_round.get_type()
	var bank = round_type.associated_question_bank

	var report = """\
		Opened round report:
			round index: {index} of {total}
			round tier: {tier}
			battle type: {battle_type}, is boss: {is_boss}
			base gold: {base_gold}
			question pool: {bank_name} with {bank_questions_amount} questions
			questions per round: {questions_per_round}
			enemy character: {enemy}
			enemy health: {enemy_health}/{enemy_max_health}
			player health: {player_health}/{player_max_health}
			treasure bag: gold={gold}, items={items_amount}"""

	return report.format({
		index = _round_index,
		total = _round_types.size(),
		tier = _current_round.get_tier(),
		battle_type = round_type.battle_type,
		is_boss = round_type.is_boss(),
		base_gold = round_type.base_gold,
		bank_name = bank.name if bank else "<none>",
		bank_questions_amount = bank.question_types.size() if bank else 0,
		questions_per_round = QUESTIONS_PER_ROUND,
		enemy = _current_enemy,
		enemy_health = _current_enemy.get_health().get_health(),
		enemy_max_health = _current_enemy.get_health().get_max_health(),
		player_health = _player_character.get_health().get_health(),
		player_max_health = _player_character.get_health().get_max_health(),
		gold = _treasure_bag.get_total_gold(),
		items_amount = _treasure_bag.get_items().size()
	})


func _character_type_names(types: Array[CharacterType]) -> String:

	var names := PackedStringArray()
	for type in types:
		names.append(type.name)

	return ", ".join(names) if !names.is_empty() else "<none>"


func _countdown_seconds_of(bank: QuestionBank) -> String:

	if !bank or bank.question_types.is_empty():
		return "<none>"

	var seconds := PackedStringArray()
	for question_type in bank.question_types:
		seconds.append(String.num_int64(question_type.seconds_to_answer))

	return ", ".join(seconds)


func _collect_round_types(round_sequence: RoundSequence) -> Array[RoundType]:
	var round_types: Array[RoundType] = []
	if round_sequence:
		print_debug("Unable to collect round types. Round sequence is empty...")
		round_types.assign(round_sequence.get_round_types())
	return round_types


func _has_next_round() -> bool:
	return _round_index + 1 < _round_types.size()


## This method is asynchronous.
func _transition_to(state: BattleState) -> void:
	if _is_cancelled:
		return
	await state.enter()


## This method is asynchronous.
func _wait_presentation_delay() -> void:
	if !_host or !_host.is_inside_tree():
		return
	await _host.get_tree().create_timer(RESULT_DELAY_SECONDS).timeout


func _open_round() -> void:

	_round_index += 1
	_is_round_over = false
	_question_number = 0

	var round_type = _round_types[_round_index]
	var tier = _level_tier()

	var enemy_type = _pick_enemy_type(round_type)
	var enemy_character = Character.of(enemy_type, tier)
	_arena.set_enemy_character(enemy_character)
	_current_enemy = enemy_character

	_current_round = Round.new(round_type, tier, enemy_character)

	var question_bank = round_type.associated_question_bank
	_question_pool = QuestionPool.new(question_bank) if question_bank else null

	round_started.emit(_round_index, _current_round)

	print_debug("Started round {index}...".format({ index = _round_index }))
	print_debug(_opened_round_report())


func _pick_enemy_type(round_type: RoundType) -> CharacterType:

	var possible = round_type.possible_enemy_types
	if possible.is_empty():
		return _session.get_character_type()

	return possible.pick_random()


## Produces the next question of the current round, `null` when
## the round has no questions left.
func _next_question() -> Question:

	if !_question_pool or _question_number >= QUESTIONS_PER_ROUND:
		return null

	var question = _question_pool.queue()
	if !question:
		return null

	_question_number += 1
	_current_question = question
	return _current_question


func _resolve_answer() -> AnswerResult:

	var correct_index = _current_question.get_type().correct_answer_index
	return AnswerResult.new(_answer_reason, _answer_index, correct_index)


func _apply_answer_outcome(result: AnswerResult) -> void:

	if result.is_correct():
		_current_enemy.do_damage(DamageInfo.with(correct_answer_damage))
		damage_applied.emit(_current_enemy, correct_answer_damage)
		return

	_player_character.do_damage(DamageInfo.with(wrong_answer_damage))
	damage_applied.emit(_player_character, wrong_answer_damage)


func _start_countdown(question: Question) -> void:

	_stop_countdown()

	if !question.has_timeout():
		countdown_ticked.emit(-1)
		return

	_countdown = CountdownTimer.new(question.get_timeout())
	_countdown.tick.connect(_on_countdown_tick)
	_countdown.timeout.connect(_on_countdown_timeout)
	_countdown.start()


func _stop_countdown() -> void:

	if !_countdown:
		return

	_countdown.tick.disconnect(_on_countdown_tick)
	_countdown.timeout.disconnect(_on_countdown_timeout)
	_countdown.stop()
	_countdown = null


func _finish_round() -> void:

	var round_type = _current_round.get_type()
	var treasure = _loot_manager.roll_treasure(round_type, _current_round.get_tier())
	_treasure_bag.add(treasure)

	treasure_added.emit(treasure)
	round_passed.emit(_round_index)

	if !_has_next_round():
		_finish_attempt(true)


func _finish_attempt(is_win: bool) -> void:

	if _is_attempt_over:
		return

	_is_attempt_over = true
	_stop_countdown()
	attempt_over.emit(LevelResult.of(is_win, _treasure_bag))


func _make_answer_available(index: int, reason: AnswerResult.EndReasons) -> void:

	if _is_cancelled or _answer_arrived:
		return

	_answer_index = index
	_answer_reason = reason
	_answer_arrived = true

	answer_submitted.emit()

#endregion


#region event handlers

func _on_character_died(character: Character) -> void:

	if _is_cancelled:
		return

	if character == _player_character:
		_is_player_dead = true
		_finish_attempt(false)
		return

	_is_round_over = true


func _on_countdown_tick(seconds: int) -> void:
	countdown_ticked.emit(seconds)


func _on_countdown_timeout() -> void:
	_make_answer_available(-1, AnswerResult.EndReasons.NO_ANSWER)

#endregion



#region inner classes

## Base class for all battle states of `BattleManager`.
@abstract
class BattleState extends RefCounted:

	var manager: BattleManager

	func _init(manager: BattleManager) -> void:
		self.manager = manager

	## This method is asynchronous.
	func enter() -> void:
		print_debug("Entered {state} state".format({ state = self }))
		await on_enter()

	func _to_string() -> String:
		return "BattleState(qualified_name=\"{name}\")".format({
			name = get_qualified_name()
		})

	@abstract func on_enter() -> void
	@abstract func get_qualified_name() -> String


class IntroState extends BattleState:

	func on_enter() -> void:
		await manager._transition_to(MakeRoundState.new(manager))

	func get_qualified_name() -> String:
		return "IntroState"


class MakeRoundState extends BattleState:

	func on_enter() -> void:

		if !manager._has_next_round():
			print_debug("Rounds over...")
			await manager._transition_to(OutroState.new(manager))
			return

		manager._open_round()
		await manager._transition_to(ShowQuestionState.new(manager))

	func get_qualified_name() -> String:
		return "MakeRoundState"


class ShowQuestionState extends BattleState:

	func on_enter() -> void:

		var question = manager._next_question()
		if !question:
			await manager._transition_to(RoundOverState.new(manager))
			return

		manager._answer_arrived = false
		manager.question_presented.emit(question, manager._question_number)
		manager._start_countdown(question)

		await manager._transition_to(AwaitAnswerState.new(manager))

	func get_qualified_name() -> String:
		return "ShowQuestionState"


class AwaitAnswerState extends BattleState:

	func on_enter() -> void:

		while not manager._answer_arrived and not manager._is_cancelled:
			await manager.answer_submitted

		if manager._is_cancelled:
			return

		manager._stop_countdown()

		var result = manager._resolve_answer()
		manager.answer_resolved.emit(result)

		await manager._transition_to(ResolveState.new(manager, result))

	func get_qualified_name() -> String:
		return "AwaitAnswerState"


class ResolveState extends BattleState:

	var result: AnswerResult

	func _init(manager: BattleManager, result: AnswerResult) -> void:
		super(manager)
		self.result = result

	func on_enter() -> void:

		await manager._wait_presentation_delay()

		if manager._is_cancelled:
			return

		manager._apply_answer_outcome(result)

		if manager._is_attempt_over:
			return

		if manager._is_round_over:
			await manager._transition_to(RoundOverState.new(manager))
			return

		await manager._transition_to(ShowQuestionState.new(manager))

	func get_qualified_name() -> String:
		return "ResolveState"


class RoundOverState extends BattleState:

	func on_enter() -> void:

		manager._finish_round()

		if manager._is_attempt_over:
			return

		await manager._transition_to(MakeRoundState.new(manager))

	func get_qualified_name() -> String:
		return "RoundOverState"


class OutroState extends BattleState:

	func on_enter() -> void:
		manager._finish_attempt(false)

	func get_qualified_name() -> String:
		return "OutroState"

#endregion

