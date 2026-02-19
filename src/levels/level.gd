class_name Level


#region signals

signal last_attempt_over(result: LevelAttempt.Result)

#endregion


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
	var attempt = LevelAttempt.on(self, player_data)
	attempt.over.connect(_on_attempt_over, CONNECT_ONE_SHOT)
	_last_attempt = attempt
	return attempt

#endregion


#region event handlers

func _on_attempt_over(result: LevelAttempt.Result) -> void:
	last_attempt_over.emit(result)
	print_debug("Last attempt {attemp} is over with result {result}".format({
		attempt = _last_attempt,
		result = result
	}))

#endregion


#region static

static func of(tier: int, info: LevelInfo) -> Level:
	return Level.new(info, tier)

#endregion
