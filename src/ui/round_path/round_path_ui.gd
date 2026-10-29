## Passive view of the whole round path (list of round indicators).
class_name RoundPathUI extends Control


#region constants

const ROUND_PATH_UI_SCENE = preload("uid://duu8256yvkrev")

#endregion


#region fields

var _indicators: Dictionary[StringName, RoundIndicatorUI] = {}

@export var _indicator_list: Control

#endregion


#region public (presenter-facing)

func add_indicator(data: RoundIndicatorViewData) -> void:
	var indicator = RoundIndicatorUI.of(data)
	_indicators[data.id] = indicator
	_indicator_list.add_child(indicator)


func set_indicator_state(id: StringName, state: RoundIndicatorViewData.State) -> void:
	var indicator = _indicators.get(id)
	if !indicator:
		push_warning("There is no round indicator with id: ", id)
		return
	indicator.set_state(state)

#endregion


#region static

static func make() -> RoundPathUI:
	return ROUND_PATH_UI_SCENE.instantiate() as RoundPathUI

#endregion
