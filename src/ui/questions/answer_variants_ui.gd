class_name AnswerVariantsUI extends Control


#region constants

const ANSWER_VARIANTS_UI_SCENE = preload("uid://hmx4kj3amtkw")

#endregion


#region signals

signal answered(variant_idx: int)

#endregion


#region fields

@export var _container: Container

#endregion


#region builtins

#endregion


#region getters/setters

func _set_interactive(value: bool) -> void:
	for child in _container.get_children():
		if child is Button:
			child.disabled = !value

#endregion


#region public

## This method updates answer button according to the passed `variants` list and
## makes grid of answer buttons active (so each button becomes interactive), so user
## can choose his answer.
func do_questionare_with(variants: Array[String]) -> void:
	_refresh_buttons_with(variants)
	_set_interactive(true)


## This method is async.
## This method shows correct/incorrect answer.
func show_result(question_result: Question.Result) -> void:

	var correct_idx = question_result.get_correct_answer_idx()
	var correct_button = _container.get_child(correct_idx) as AnswerVariantButtonUI
	correct_button.set_validation(AnswerVariantButtonUI.ValidationFlags.CORRECT)

	var user_answer_idx = question_result.get_user_answer_idx()
	if correct_idx != user_answer_idx:
		var incorrect_button = _container.get_child(user_answer_idx) as AnswerVariantButtonUI
		incorrect_button.set_validation(AnswerVariantButtonUI.ValidationFlags.INCORRECT)
	
	#FIXME - remove this, create animation and await it instead of this
	await get_tree().create_timer(1.5).timeout

#endregion


#region private

func _refresh_buttons_with(variants: Array[String]) -> void:
	
	for child in _container.get_children():
		_container.remove_child(child)

	for variant_idx in variants.size():
		var variant = variants[variant_idx]
		var variant_button_ui: Button = AnswerVariantButtonUI.of(variant)
		variant_button_ui.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		variant_button_ui.pressed.connect(_on_button_pressed.bind(variant_idx))
		_container.add_child(variant_button_ui)

#endregion


#region event handlers

func _on_button_pressed(variant_idx: int) -> void:
	_set_interactive(false)
	emit_signal("answered", variant_idx)

#endregion


#region static

static func make() -> AnswerVariantsUI:
	var answer_variants_ui = ANSWER_VARIANTS_UI_SCENE.instantiate() as AnswerVariantsUI
	return answer_variants_ui

#endregion
