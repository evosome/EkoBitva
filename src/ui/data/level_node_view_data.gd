## View-layer data holder describing a roadmap level node icon.
class_name LevelNodeViewData extends RefCounted


#region enums

enum State {
	LOCKED,
	UNLOCKED,
	PASSED
}

#endregion


#region fields

var id: StringName
var position: Vector2
var icon: Texture2D
var state: State = State.LOCKED

#endregion


#region static

static func of(id: StringName, position: Vector2, icon: Texture2D, state: State = State.LOCKED) -> LevelNodeViewData:
	var data = LevelNodeViewData.new()
	data.id = id
	data.position = position
	data.icon = icon
	data.state = state
	return data

#endregion
