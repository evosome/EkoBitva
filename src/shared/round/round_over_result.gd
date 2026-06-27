class_name RoundOverResult


#region enums

enum RoundEndReason {
	TIMEOUT,
	ANSWERED
}

#endregion


#region fields

var _end_reason: RoundEndReason
var _treasure: Treasure

#endregion


#region builtins

func _init(end_reason: RoundEndReason, treasure: Treasure) -> void:
	_end_reason = end_reason
	_treasure = treasure

#endregion


#region getters/setters

func get_end_reason() -> RoundEndReason:
	return _end_reason


func get_treasure() -> Treasure:
	return _treasure

#endregion
