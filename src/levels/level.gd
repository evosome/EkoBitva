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


#region public

func make_attempt(player_data: PlayerInfo) -> LevelAttempt:
	var arena_info = _info.arena_info
	var arena = Arena.make(arena_info)
	var round_sequencer = _info.round_sequencer
	return LevelAttempt.on(arena, player_data, round_sequencer)

#endregion


#region static

static func of(tier: int, info: LevelInfo) -> Level:
	return Level.new(info, tier)

#endregion
