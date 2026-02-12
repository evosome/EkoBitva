extends Control


#region constants

const TEST_QUESTION_BANK = preload("res://resources/questions/test_simple_questions.tres")

#endregion


#region builtins

func _ready() -> void:
	var question_layer = QuestionLayerUI.make()
	add_child(question_layer)
	
	var random_question_type: QuestionType = TEST_QUESTION_BANK.question_types.pick_random()
	var random_question = Question.of(random_question_type, TEST_QUESTION_BANK)

	var user_choice = await question_layer.ask_question(random_question)
	var answer_result = random_question.answer(user_choice)

	await question_layer.show_result(answer_result)

#endregion
