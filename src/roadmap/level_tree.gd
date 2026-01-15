class_name LevelTree


#region enums

enum NodeStates {
	LOCKED,
	UNLOCKED,
	PASSED
}

#endregion


#region fields

var _root: _Node = null

#endregion


#region getters/setters

func get_root() -> LevelNode:
	return null

#endregion


#region inner classes

class _Node extends RefCounted:

	var _position: Vector2i
	var _state: NodeStates = NodeStates.LOCKED
	var _level: Level
	var _parent: _Node
	var _children: Array[_Node] = []

	func _init(level: Level, position: Vector2i, parent: _Node = null):
		_position = position
		_level = level
		_parent = parent
		_children = []

	func get_position() -> Vector2i:
		return _position

	func get_state() -> NodeStates:
		return _state
	
	func set_state(value: NodeStates) -> void:
		_state = value

	func get_level() -> Level:
		return _level

	func get_parent() -> _Node:
		return _parent

	func add_child(node: _Node) -> void:
		_children.append(node)

	func get_children() -> Array[_Node]:
		return _children


class LevelNode extends RefCounted:
	
	var _real_node: _Node

	func _init(real_node: _Node) -> void:
		_real_node = real_node
	
	func get_level() -> Level:
		return _real_node.get_level()

	func get_state() -> NodeStates:
		return _real_node.get_state()
	
	func get_position() -> Vector2i:
		return _real_node.get_position()
	
	func create_child(level: Level, position: Vector2i) -> LevelNode:
		var new_node = _Node.new(level, position, _real_node)
		_real_node.add_child(new_node)
		return LevelNode.new(new_node)

#endregion
