## Presenter of the battle screen. It contains no battle rules at all:
## `BattleManager` decides what happens, this screen only mirrors it into
## passive views and forwards the player answer back to the manager.
class_name BattleScreen extends Screen


#region fields

@export var _question_layer: QuestionLayerUI
@export var _battle_viewport_container: Node
@export var _round_indicator_path_container: Control
@export var _treasure_bag_container: Control

var _game: GameContext
var _battle: BattleManager

var _round_path_ui: RoundPathUI
var _treasure_bag_ui: TreasureBagUI

#endregion


#region screen

func on_enter(ctx) -> void:

	_game = ctx.game
	_battle = ctx.battle

	if !_battle:
		push_error("Battle screen was entered without battle manager")
		return

	_battle_viewport_container.add_child(_battle.attempt().get_arena())
	_setup_round_path()
	_setup_treasure_bag()
	_connect_battle()

	_battle.run()


func on_exit() -> void:
	_disconnect_battle()
	_free_views()
	if _game:
		_game.end_battle()

#endregion


#region private

func _setup_round_path() -> void:
	_round_path_ui = RoundPathUI.make()
	_round_indicator_path_container.add_child(_round_path_ui)
	var index = 0
	for round_type in _battle.round_types():
		_round_path_ui.add_indicator(ViewDataFactory.round_indicator(index, round_type))
		index += 1


func _setup_treasure_bag() -> void:
	_treasure_bag_ui = TreasureBagUI.make()
	_treasure_bag_container.add_child(_treasure_bag_ui)


func _connect_battle() -> void:
	_battle.question_presented.connect(_on_question_presented)
	_battle.countdown_ticked.connect(_on_countdown_ticked)
	_battle.answer_resolved.connect(_on_answer_resolved)
	_battle.round_started.connect(_on_round_started)
	_battle.round_passed.connect(_on_round_passed)
	_battle.treasure_added.connect(_on_treasure_added)
	_battle.attempt_over.connect(_on_attempt_over)
	_question_layer.answer_chosen.connect(_on_answer_chosen)


func _disconnect_battle() -> void:

	if _battle:
		_battle.question_presented.disconnect(_on_question_presented)
		_battle.countdown_ticked.disconnect(_on_countdown_ticked)
		_battle.answer_resolved.disconnect(_on_answer_resolved)
		_battle.round_started.disconnect(_on_round_started)
		_battle.round_passed.disconnect(_on_round_passed)
		_battle.treasure_added.disconnect(_on_treasure_added)
		_battle.attempt_over.disconnect(_on_attempt_over)

	_question_layer.answer_chosen.disconnect(_on_answer_chosen)


func _free_views() -> void:

	if _round_path_ui:
		_round_path_ui.queue_free()
		_round_path_ui = null

	if _treasure_bag_ui:
		_treasure_bag_ui.queue_free()
		_treasure_bag_ui = null

	_question_layer.hide_question()
	_question_layer.reset_countdown()

	var arena = _battle.attempt().get_arena() if _battle else null
	if arena and arena.get_parent():
		arena.get_parent().remove_child(arena)
		arena.queue_free()


func _round_indicator_id(index: int) -> StringName:
	return &"round_%d" % index

#endregion


#region event handlers

func _on_question_presented(question: Question, number: int) -> void:
	_question_layer.show_question(ViewDataFactory.question(question, number))


func _on_countdown_ticked(seconds: int) -> void:
	_question_layer.set_countdown(seconds)


func _on_answer_resolved(result: AnswerResult) -> void:
	_question_layer.show_result(ViewDataFactory.answer_result(result))


func _on_round_started(index: int, _round: Round) -> void:
	_round_path_ui.set_indicator_state(_round_indicator_id(index), RoundIndicatorViewData.State.CURRENT)


func _on_round_passed(index: int) -> void:
	_round_path_ui.set_indicator_state(_round_indicator_id(index), RoundIndicatorViewData.State.PASSED)


func _on_treasure_added(treasure: Treasure) -> void:
	var treasure_bag = _battle.attempt().get_treasure_bag()
	_treasure_bag_ui.set_gold(treasure_bag.get_total_gold())
	_treasure_bag_ui.add_items(ViewDataFactory.treasure_items(treasure))


func _on_answer_chosen(variant_idx: int) -> void:
	_battle.submit_answer(variant_idx)


func _on_attempt_over(result: LevelResult) -> void:
	_game.session.apply_level_result(_battle.level(), result)
	_game.navigation.switch_to("LevelSelectionScreen", Screen.Context.new(_game))

#endregion


#region inner classes

## Context of the battle screen carries the already started battle manager,
## created by `LevelSelectionScreen` through `GameContext.start_battle`.
class Context extends Screen.Context:

	var battle: BattleManager

	func _init(game: GameContext = null, battle: BattleManager = null) -> void:
		super(game)
		self.battle = battle

#endregion
