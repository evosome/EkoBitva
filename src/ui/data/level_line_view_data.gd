## View-layer data holder describing a line between two roadmap nodes.
class_name LevelLineViewData extends RefCounted


#region fields

var start: Vector2
var end: Vector2
var state: LevelNodeViewData.State = LevelNodeViewData.State.LOCKED

#endregion


#region static

static func between(start: Vector2, end: Vector2, state: LevelNodeViewData.State) -> LevelLineViewData:
	var data = LevelLineViewData.new()
	data.start = start
	data.end = end
	data.state = state
	return data

#endregion
