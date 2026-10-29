## Passive view of a line between two roadmap nodes.
class_name LevelLine extends Line2D


#region constants

const LOCKED_COLOR = Color.DARK_GRAY
const UNLOCKED_COLOR = Color.GREEN
const PASSED_COLOR = Color.WHITE

const LEVEL_LINE = preload("uid://caxio728cqjm2")

#endregion


#region fields

var _pending_state: LevelNodeViewData.State = LevelNodeViewData.State.LOCKED

#endregion


#region builtins

func _ready() -> void:
	_change_color_by_state(_pending_state)

#endregion


#region setters (presenter-facing)

func set_endpoints(start: Vector2, end: Vector2) -> void:
	points = [start, end]


func set_state(state: LevelNodeViewData.State) -> void:
	_pending_state = state
	_change_color_by_state(state)

#endregion


#region private

func _change_color_by_state(state: LevelNodeViewData.State) -> void:
	var line_color
	match state:
		LevelNodeViewData.State.LOCKED:
			line_color = LOCKED_COLOR
		LevelNodeViewData.State.UNLOCKED:
			line_color = UNLOCKED_COLOR
		_:
			line_color = PASSED_COLOR
	default_color = line_color

#endregion


#region static

static func of(data: LevelLineViewData) -> LevelLine:
	var level_line = LEVEL_LINE.instantiate() as LevelLine
	level_line._pending_state = data.state
	level_line.set_endpoints(data.start, data.end)
	return level_line

#endregion
