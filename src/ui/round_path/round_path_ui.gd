class_name RoundPathUI extends Control


#region constants

const ROUND_PATH_UI_SCENE = preload("uid://duu8256yvkrev")

#endregion


#region fields

var _round_path: RoundPath

@export var _indicator_list: Control

#endregion


#region builtins

func _ready() -> void:
	_add_round_indicators()

#endregion


#region private

func _add_round_indicators() -> void:
	var checkpoints = _round_path.get_checkpoints()
	for checkpoint in checkpoints:
		var round_indicator_ui = RoundIndicatorUI.of(checkpoint)
		_indicator_list.add_child(round_indicator_ui)

#endregion


#region static

static func of(round_path: RoundPath) -> RoundPathUI:
	var round_path_ui = ROUND_PATH_UI_SCENE.instantiate() as RoundPathUI
	round_path_ui._round_path = round_path
	return round_path_ui

#endregion
