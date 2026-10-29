## View-layer data holder describing one round checkpoint on the round path.
class_name RoundIndicatorViewData extends RefCounted


#region enums

enum State {
	## Round is not played yet
	PENDING,
	## Round is being played right now
	CURRENT,
	## Round is already played
	PASSED
}

#endregion


#region fields

var id: StringName
var is_boss: bool = false
var state: State = State.PENDING

#endregion


#region static

static func of(id: StringName, is_boss: bool = false, state: State = State.PENDING) -> RoundIndicatorViewData:
	var data = RoundIndicatorViewData.new()
	data.id = id
	data.is_boss = is_boss
	data.state = state
	return data

#endregion
