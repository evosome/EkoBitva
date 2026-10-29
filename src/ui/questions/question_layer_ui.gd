## Passive view of the whole question layer.
## Consumes `QuestionViewData` / `AnswerResultViewData` and reports
## the chosen answer back to the presenter.
class_name QuestionLayerUI extends Control


#region constants

const QUESTION_LAYER_UI_SCENE = preload("uid://vl443t31pkj6")

const CORRECT_TITLE_TEXT = "Правильно!"
const INCORRECT_TITLE_TEXT = "Неправильно!"

#endregion


#region signals

signal answer_chosen(variant_idx: int)

#endregion


#region fields

@export var _question_title_label: Label
@export var _question_number_label: Label

@export var _question_bank_name_label: Label
@export var _question_bank_color_control: Control

@export var _answer_variants_ui: AnswerVariantsUI
@export var _countdown_timer_ui: CountdownTimerUI

#endregion


#region builtins

func _ready() -> void:
	visible = false
	_answer_variants_ui.answered.connect(_on_answer_variant_pressed)

#endregion


#region public (presenter-facing)

## Shows the question described by `data`.
func show_question(data: QuestionViewData) -> void:
	_question_number_label.text = String.num_int64(data.number)
	_question_title_label.text = data.title
	_question_bank_name_label.text = data.bank_name
	_question_bank_color_control.modulate = data.bank_color

	if data.countdown_seconds < 0:
		_countdown_timer_ui.set_infinite()
	else:
		_countdown_timer_ui.set_remaining(data.countdown_seconds)

	_answer_variants_ui.set_variants(data.answer_variants)
	_answer_variants_ui.set_interactive(true)
	visible = true


## Paints the correctness title and highlights answer buttons.
func show_result(data: AnswerResultViewData) -> void:
	_question_title_label.text = CORRECT_TITLE_TEXT if data.is_correct else INCORRECT_TITLE_TEXT
	_answer_variants_ui.mark_result(data.correct_index, data.user_index)


## Updates the remaining time of the currently shown question.
func set_countdown(seconds: int) -> void:
	_countdown_timer_ui.set_remaining(seconds)


## Stops the countdown and shows the `no timeout` label.
func reset_countdown() -> void:
	_countdown_timer_ui.reset()


func hide_question() -> void:
	visible = false

#endregion


#region event handlers

func _on_answer_variant_pressed(variant_idx: int) -> void:
	answer_chosen.emit(variant_idx)

#endregion


#region static

static func make() -> QuestionLayerUI:
	return QUESTION_LAYER_UI_SCENE.instantiate() as QuestionLayerUI

#endregion
