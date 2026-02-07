class_name RoundIndicatorUI extends Control


#region constants

const COMMON_ROUND_COLOR = Color.WHITE
const BOSS_ROUND_COLOR = Color.RED

const PASSED_ROUND_BRIGHTNESS = 0.3
const UNPASSED_ROUND_BRIGHTNESS = 0.8
const CURRENT_ROUND_BRIGHTNESS = 1.0

const COLOR_MAP = {
	RoundInfo.BattleTypes.COMMON: COMMON_ROUND_COLOR,
	RoundInfo.BattleTypes.BOSS: BOSS_ROUND_COLOR
}

#endregion


#region fields

var _checkpoint: RoundPath.Checkpoint

@export var _indicator_texture_rect: TextureRect

#endregion


#region builtins

func _ready() -> void:
	var round_info = _checkpoint.get_round_info()
	
	var battle_type = round_info.battle_type
	_set_indicator_color_by(battle_type)
	_set_indicator_brightness(UNPASSED_ROUND_BRIGHTNESS)

	_checkpoint.passed.connect(_on_checkpoint_passed)

#endregion


#region private

func _set_indicator_color(value: Color) -> void:
	_indicator_texture_rect.modulate = value


func _set_indicator_color_by(battle_type: RoundInfo.BattleTypes) -> void:
	var color = COLOR_MAP[battle_type]
	_set_indicator_color(color)


func _set_indicator_brightness(value: float) -> void:
	_indicator_texture_rect.modulate.v = value

#endregion


#region event handlers

func _on_checkpoint_passed() -> void:
	_set_indicator_brightness(PASSED_ROUND_BRIGHTNESS)

#endregion


#region static

static func of(checkpoint: RoundPath.Checkpoint) -> RoundIndicatorUI:
	var round_indicator_ui = Registry.instantiate(Id.of_game("scenes.ui.round_path", "RoundIndicator")) as RoundIndicatorUI
	round_indicator_ui._checkpoint = checkpoint
	return round_indicator_ui

#endregion
