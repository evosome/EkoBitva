class_name LevelLine extends Line2D


#region constants

const LOCKED_COLOR = Color.DARK_GRAY
const UNLOCKED_COLOR = Color.GREEN
const PASSED_COLOR = Color.WHITE

#endregion


#region fields

var _node: LevelTree.LevelNode
var _parent: LevelTree.LevelNode

#endregion


#region builtins

func _ready() -> void:
	points = [_parent.get_position(), _node.get_position()]

	var current_node_state = _node.get_state()
	_change_color_by_state(current_node_state)

	_node.state_changed.connect(_on_state_changed)

#endregion


#region private

func _change_color_by_state(state: LevelTree.NodeStates) -> void:
	var line_color
	match state:
		LevelTree.NodeStates.LOCKED:
			line_color = LOCKED_COLOR
		LevelTree.NodeStates.UNLOCKED:
			line_color = UNLOCKED_COLOR
		_:
			line_color = PASSED_COLOR
	default_color = line_color

#endregion


#region event handlers

func _on_state_changed(state: LevelTree.NodeStates) -> void:
	_change_color_by_state(state)

#endregion


#region static

static func between(node: LevelTree.LevelNode, parent: LevelTree.LevelNode) -> LevelLine:
	var level_line = Registry.instantiate(Id.of_game("scenes.roadmap", "LevelLine")) as LevelLine
	level_line._node = node
	level_line._parent = parent
	return level_line

#endregion
