class_name BattleScreen extends Screen


#region fields

@export var _question_layer: QuestionLayerUI

#endregion


#region overrides

func on_enter(ctx: Context) -> void:

	var battle_context = BattleContext.new()
	battle_context.level_attempt = ctx.level_attempt
	battle_context.question_layer = _question_layer

	await IntroState.new(battle_context).enter()

	#switch_to()


func on_exit() -> void:
	pass

#endregion


#region inner classes

class Context:
	var level_attempt: LevelAttempt


class BattleContext:
	var level_attempt: LevelAttempt
	var current_round: Round
	var question_layer: QuestionLayerUI
	var current_question: Question


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
		await transition_to(MakeRoundState.new(ctx))
	
	func get_qualified_name() -> String:
		return "IntroState"


class MakeRoundState extends BattleState:

	func on_enter() -> void:
		var level_attempt = ctx.level_attempt

		var new_round = level_attempt.next()
		ctx.current_round = new_round

		await transition_to(ShowQuestionState.new(ctx))
	
	func get_qualified_name() -> String:
		return "MakeRoundState"

class ShowQuestionState extends BattleState:
	
	func on_enter() -> void:
		var current_round = ctx.current_round

		var current_question = current_round.get_next_question()
		ctx.current_question = current_question

		var question_layer = ctx.question_layer
		await question_layer.show_question(current_question)

		await transition_to(QuestionAnswerState.new(ctx))
	
	func get_qualified_name() -> String:
		return "ShowQuestionState"


class QuestionAnswerState extends BattleState:
	
	func on_enter() -> void:

		var current_question = ctx.current_question
		
		var question_layer = ctx.question_layer
		
		current_question.start()
		var answer_result = await current_question.over

		await question_layer.show_result(answer_result)

		await transition_to(BattleShowState.new(ctx))
	
	func get_qualified_name() -> String:
		return "QuestionAnswerState"


class BattleShowState extends BattleState:
	
	func on_enter() -> void:
		
		var current_attempt = ctx.level_attempt

		if !current_attempt.is_over():
			_continue_game()
		else:
			await transition_to(OutroState.new(ctx))
		
	func _continue_game() -> void:
		var current_round = ctx.current_round
		if !current_round.is_over():
			await transition_to(ShowQuestionState.new(ctx))
	
	func get_qualified_name() -> String:
		return "BattleShowState"


class OutroState extends BattleState:
	
	func on_enter() -> void:
		pass
	
	func get_qualified_name() -> String:
		return "OutroState"

#endregion
