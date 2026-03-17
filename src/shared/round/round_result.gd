class_name RoundResult extends RefCounted


#region enums

enum RoundEndReason {
	TIMEOUT,
	ANSWERED
}

#endregion


#region fields

var _is_win: bool
var _end_reason: RoundEndReason
var _treasure: Treasure

#endregion


#region builtins

func _init(is_win: bool, end_reason: RoundEndReason, treasure: Treasure) -> void:
	_is_win = is_win
	_end_reason = end_reason
	_treasure = treasure

#endregion


#region getters/setters

func is_win() -> bool:
	return _is_win


func get_end_reason() -> RoundEndReason:
	return _end_reason


func get_treasure() -> Treasure:
	return _treasure

#endregion
