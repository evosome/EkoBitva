class_name LevelTree


#region enums

enum NodeStates {
	LOCKED,
	UNLOCKED,
	PASSED
}

#endregion


#region signals

signal node_added(node: LevelNode, parent: LevelNode)

#endregion


#region fields

var _root: LevelNode = null

#endregion


#region builtins

#endregion


#region getters/setters


func create_root(level: Level, position: Vector2) -> LevelNode:
	if _root:
		push_error("Root of level tree is already existing!")
		return
	
	var root = LevelNode.new(self, level, position)
	_root = root
	
	root.unlock()
	node_added.emit(root, null)
	
	return root


func get_root() -> LevelNode:
	return _root

#endregion


#region inner classes

class LevelNode extends RefCounted:

	signal state_changed(state: NodeStates)

	var _tree: LevelTree
	var _position: Vector2i
	var _state: NodeStates = NodeStates.LOCKED
	var _level: Level
	var _parent: LevelNode
	var _children: Array[LevelNode] = []

	func _init(tree: LevelTree, level: Level, position: Vector2, parent: LevelNode = null):
		_tree = tree
		_position = position
		_level = level
		_parent = parent
		_children = []
	
	func get_level() -> Level:
		return _level

	func get_position() -> Vector2:
		return _position

	func get_state() -> NodeStates:
		return _state
	
	func _set_state(value: NodeStates) -> void:
		_state = value
		state_changed.emit(value)
	
	func get_parent() -> LevelNode:
		return _parent

	func create_child(level: Level, position: Vector2) -> LevelNode:
		var new_node = LevelNode.new(_tree, level, position, self)
		_children.append(new_node)
		_tree.node_added.emit(new_node, self)
		return new_node

	func get_children() -> Array[LevelNode]:
		return _children
	
	func unlock() -> void:
		if _parent && _parent.get_state() == NodeStates.LOCKED:
			return
		
		_set_state(NodeStates.UNLOCKED)

	func pass_() -> void:
		if _parent && _parent.get_state() == NodeStates.LOCKED:
			return
		
		_set_state(NodeStates.PASSED)
		_unlock_children()
	
	func _unlock_children() -> void:
		for child in _children:
			child.unlock()

#endregion
