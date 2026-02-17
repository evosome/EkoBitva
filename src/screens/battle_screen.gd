class_name BattleScreen extends Screen


#region fields

var _player_info: PlayerInfo
var _roadmap: Roadmap

@export var _question_layer: QuestionLayerUI
@export var _battle_viewport_container: Node

#endregion


#region overrides

func on_enter(ctx: Context) -> void:
	
	_player_info = ctx.player_info
	_roadmap = ctx.roadmap

	var level_attempt = ctx.level_attempt
	var attempt_arena = level_attempt.get_arena()
	_battle_viewport_container.add_child(attempt_arena)

	var battle_context = BattleContext.new()
	battle_context.screen = self
	battle_context.level_attempt = level_attempt
	battle_context.question_layer = _question_layer

	IntroState.new(battle_context).enter()


func on_exit() -> void:
	pass

#endregion


#region private

func _switch_back_to_level_selection() -> void:
	var level_selection_screen = Registry.instantiate(Id.of_game("scenes.screens", "LevelSelectionScreen"))
	var context = LevelSelectionScreen.Context.new()
	context.roadmap = _roadmap
	context.player_data = _player_info
	switch_to(level_selection_screen, context)

#endregion


#region inner classes

class Context:
	var roadmap: Roadmap
	var player_info: PlayerInfo
	var level_attempt: LevelAttempt


class BattleContext:
	var screen: BattleScreen
	var level_attempt: LevelAttempt
	var current_round: Round
	var question_layer: QuestionLayerUI
	var current_question: Question
	var last_answer_result: Question.Result


## Base class for all battle states
@abstract
class BattleState extends RefCounted:

	var ctx: BattleContext

	func _init(ctx) -> void:
		self.ctx = ctx
	
	func enter() -> void:
		print_debug("Entered {state} state".format({ state = self }))
		await on_enter()
	
	func transition_to(state: BattleState) -> void:
		await state.enter()
	
	func _to_string() -> String:
		return "BattleState(qualified_name=\"{name}\")".format({
			name = get_qualified_name()
		})

	@abstract func on_enter() -> void
	@abstract func get_qualified_name() -> String


class IntroState extends BattleState:

	func on_enter() -> void:
		transition_to(MakeRoundState.new(ctx))
	
	func get_qualified_name() -> String:
		return "IntroState"


class MakeRoundState extends BattleState:

	func on_enter() -> void:
		var level_attempt = ctx.level_attempt

		var new_round = level_attempt.next()
		ctx.current_round = new_round

		transition_to(ShowQuestionState.new(ctx))
	
	func get_qualified_name() -> String:
		return "MakeRoundState"

class ShowQuestionState extends BattleState:
	
	func on_enter() -> void:
		var current_round = ctx.current_round

		var current_question = current_round.get_next_question()
		ctx.current_question = current_question

		var question_layer = ctx.question_layer
		await question_layer.show_question(current_question)

		transition_to(QuestionAnswerState.new(ctx))
	
	func get_qualified_name() -> String:
		return "ShowQuestionState"


class QuestionAnswerState extends BattleState:
	
	func on_enter() -> void:

		var current_question = ctx.current_question
		
		var question_layer = ctx.question_layer
		
		current_question.start()
		var answer_result = await current_question.over
		ctx.last_answer_result = answer_result

		await question_layer.show_result(answer_result)

		transition_to(BattleShowState.new(ctx))
	
	func get_qualified_name() -> String:
		return "QuestionAnswerState"


class BattleShowState extends BattleState:
	
	func on_enter() -> void:
		
		var current_attempt = ctx.level_attempt

		if !current_attempt.is_over():
			_continue_game()
		else:
			transition_to(OutroState.new(ctx))
		
	func _continue_game() -> void:

		var current_round = ctx.current_round

		#TODO - remove this
		var current_attempt = ctx.level_attempt
		var answer_result = ctx.last_answer_result
		if answer_result.is_correct():
			current_round.get_enemy_character().do_damage(DamageInfo.new(25))
		else:
			current_attempt.get_player_character().do_damage(DamageInfo.new(25))

		if current_attempt.is_over():
			transition_to(OutroState.new(ctx))
			return

		if !current_round.is_over():
			transition_to(ShowQuestionState.new(ctx))
		else:
			transition_to(MakeRoundState.new(ctx))
	
	func get_qualified_name() -> String:
		return "BattleShowState"


class OutroState extends BattleState:
	
	func on_enter() -> void:
		ctx.screen._switch_back_to_level_selection()
	
	func get_qualified_name() -> String:
		return "OutroState"

#endregion
