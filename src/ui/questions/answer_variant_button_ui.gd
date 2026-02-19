class_name AnswerVariantButtonUI extends Button


#region constants

const ANSWER_VARIANT_BUTTON_UI_SCENE = preload("uid://br0qj680wyqvx")

#endregion


#region enums

enum ValidationFlags {
	CORRECT,
	INCORRECT,
	DEFAULT
}

#endregion


#region constants

const COLOR_CORRECT: Color = Color.GREEN
const COLOR_INCORRECT: Color = Color.RED
const COLOR_DEFAULT: Color = Color.BLUE

const VALIDATION_COLOR_MAP: Dictionary = {
	ValidationFlags.CORRECT: COLOR_CORRECT,
	ValidationFlags.INCORRECT: COLOR_INCORRECT,
	ValidationFlags.DEFAULT: COLOR_DEFAULT
}

#endregion


#region fields

var _variant: String
var _validation: ValidationFlags = ValidationFlags.DEFAULT

#endregion


#region builtins

func _ready() -> void:
	_update_button_color_by(ValidationFlags.DEFAULT)
	_set_variant_text(_variant)

#endregion


#region getters/setters

func set_validation(validation: ValidationFlags) -> void:
	_validation = validation
	_update_button_color_by(validation)


func _set_variant_text(variant: String) -> void:
	text = variant

#endregion


#region private

func _update_button_color_by(validation: ValidationFlags) -> void:
	var color = VALIDATION_COLOR_MAP.get(validation, COLOR_DEFAULT)
	modulate = color

#endregion


#region static

static func of(variant: String) -> AnswerVariantButtonUI:
	var answer_button_ui = ANSWER_VARIANT_BUTTON_UI_SCENE.instantiate() as AnswerVariantButtonUI
	answer_button_ui._variant = variant
	return answer_button_ui

#endregion
