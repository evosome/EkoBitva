## Passive view of the answer variants grid.
## It knows nothing about questions: the presenter pushes variants
## and marks the result, the view reports user clicks.
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


#region public (presenter-facing)

## Rebuilds buttons with new `variants` list. Buttons stay non-interactive
## until `set_interactive(true)` is called.
func set_variants(variants: Array[String]) -> void:
	_rebuild_buttons_with(variants)
	set_interactive(false)


## Enables or disables all answer buttons.
func set_interactive(value: bool) -> void:
	for child in _container.get_children():
		if child is Button:
			child.disabled = !value


## Highlights the correct answer and, if needed, the wrong one chosen by user.
## Pass `-1` as an index to skip highlighting of that button.
func mark_result(correct_index: int, user_index: int) -> void:

	if _has_button(correct_index):
		var correct_button = _container.get_child(correct_index) as AnswerVariantButtonUI
		correct_button.set_validation(AnswerVariantButtonUI.ValidationFlags.CORRECT)

	if user_index != correct_index and _has_button(user_index):
		var incorrect_button = _container.get_child(user_index) as AnswerVariantButtonUI
		incorrect_button.set_validation(AnswerVariantButtonUI.ValidationFlags.INCORRECT)

#endregion


#region private

func _rebuild_buttons_with(variants: Array[String]) -> void:

	for child in _container.get_children():
		_container.remove_child(child)

	for variant_idx in variants.size():
		var variant = variants[variant_idx]
		var variant_button_ui: Button = AnswerVariantButtonUI.of(variant)
		variant_button_ui.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		variant_button_ui.pressed.connect(_on_button_pressed.bind(variant_idx))
		_container.add_child(variant_button_ui)


func _has_button(index: int) -> bool:
	return index >= 0 and index < _container.get_child_count()

#endregion


#region event handlers

func _on_button_pressed(variant_idx: int) -> void:
	set_interactive(false)
	answered.emit(variant_idx)

#endregion


#region static

static func make() -> AnswerVariantsUI:
	return ANSWER_VARIANTS_UI_SCENE.instantiate() as AnswerVariantsUI

#endregion
