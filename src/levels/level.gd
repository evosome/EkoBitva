class_name Level


#region fields

var _info: LevelInfo
var _tier: int
var _last_attempt: LevelAttempt = null

#endregion


#region builtins

func _init(info: LevelInfo, tier: int):
	_info = info
	_tier = tier

#endregion


#region getters/setters

func get_info() -> LevelInfo:
	return _info


func get_tier() -> int:
	return _tier


func get_last_attempt() -> LevelAttempt:
	return _last_attempt

#endregion


#region static

static func of(tier: int, info: LevelInfo) -> Level:
	return Level.new(info, tier)

#endregion
