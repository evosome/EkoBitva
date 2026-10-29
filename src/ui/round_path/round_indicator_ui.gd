## Passive view of a single round checkpoint indicator.
class_name RoundIndicatorUI extends Control


#region constants

const ROUND_INDICATOR_UI_SCENE = preload("uid://cp6tko4640vjk")

const COMMON_ROUND_COLOR = Color.WHITE
const BOSS_ROUND_COLOR = Color.RED

const PENDING_ROUND_BRIGHTNESS = 0.8
const CURRENT_ROUND_BRIGHTNESS = 1.0
const PASSED_ROUND_BRIGHTNESS = 0.3

#endregion


#region fields

var _id: StringName = &""
var _color: Color = COMMON_ROUND_COLOR
var _state: RoundIndicatorViewData.State = RoundIndicatorViewData.State.PENDING

@export var _indicator_texture_rect: TextureRect

#endregion


#region builtins

func _ready() -> void:
	_render()

#endregion


#region getters/setters (presenter-facing)

func get_id() -> StringName:
	return _id


func set_state(state: RoundIndicatorViewData.State) -> void:
	_state = state
	_render()

#endregion


#region private

func _render() -> void:
	_indicator_texture_rect.modulate = Color(_color, 1.0)
	_indicator_texture_rect.modulate.v = _brightness()


func _brightness() -> float:
	match _state:
		RoundIndicatorViewData.State.CURRENT:
			return CURRENT_ROUND_BRIGHTNESS
		RoundIndicatorViewData.State.PASSED:
			return PASSED_ROUND_BRIGHTNESS
		_:
			return PENDING_ROUND_BRIGHTNESS

#endregion


#region static

static func of(data: RoundIndicatorViewData) -> RoundIndicatorUI:
	var round_indicator_ui = ROUND_INDICATOR_UI_SCENE.instantiate() as RoundIndicatorUI
	round_indicator_ui._id = data.id
	round_indicator_ui._color = BOSS_ROUND_COLOR if data.is_boss else COMMON_ROUND_COLOR
	round_indicator_ui._state = data.state
	return round_indicator_ui

#endregion
