class_name QuestionLayerUI extends Control


#region constants

const QUESTION_LAYER_UI_SCENE = preload("uid://vl443t31pkj6")

#endregion


#region constants

const CORRECT_TITLE_TEXT = "Правильно!"
const INCORRECT_TITLE_TEXT = "Неправильно!"

#endregion


#region fields

var _question_number: int = 0
var _current_question: Question

@export var _question_title_label: Label
@export var _question_number_label: Label

@export var _question_bank_name_label: Label
@export var _question_bank_color_control: Control

@export var _answer_variants_ui: AnswerVariantsUI
@export var _countdown_timer_ui: CountdownTimerUI

#endregion


#region builtins

func _ready() -> void:
	_set_question_visible(false)
	_answer_variants_ui.answered.connect(_on_user_answered)

#endregion


#region getters/setters

func _set_question_visible(value: bool) -> void:
	visible = value

#endregion


#region public

## This method is async.
func show_question(question: Question) -> void:

	_current_question = question

	_question_number += 1
	_update_question_number(_question_number)
	
	var question_type = question.get_type()
	_update_question_info(question_type)
	
	var question_bank = question.get_question_bank()
	_update_question_bank_info(question_bank)

	var countdown_timer = question.get_countdown()
	_update_countdown_timer(countdown_timer)

	var answer_variants = question_type.answer_variants
	_answer_variants_ui.do_questionare_with(answer_variants)

	_set_question_visible(true)


## This method is async.
func show_result(question_result: Question.Result) -> void:
	var is_correct = question_result.is_correct()
	_update_question_correct_title(is_correct)

	await _answer_variants_ui.show_result(question_result)

#endregion


#region private

func _update_question_number(question_no: int) -> void:
	_question_number_label.text = String.num_int64(question_no)


func _update_question_info(question_type: QuestionType) -> void:
	_question_title_label.text = question_type.title


func _update_question_bank_info(question_bank: QuestionBank) -> void:
	_question_bank_name_label.text = question_bank.name
	_question_bank_color_control.modulate = question_bank.color


func _update_question_correct_title(is_correct: bool) -> void:
	_question_title_label.text = CORRECT_TITLE_TEXT if is_correct else INCORRECT_TITLE_TEXT


func _update_countdown_timer(countdown_timer: CountdownTimer) -> void:
	_countdown_timer_ui.wrap_timer(countdown_timer)

#endregion


#region event handlers

func _on_user_answered(variant_idx: int) -> void:
	_current_question.answer(variant_idx)

#endregion


#region static

static func make() -> QuestionLayerUI:
	var question_layer_ui = QUESTION_LAYER_UI_SCENE.instantiate() as QuestionLayerUI
	return question_layer_ui

#endregion
