class_name RoadmapScene extends Node2D


#region signals

signal icon_selected(level_icon: LevelIcon)

#endregion


#region fields

var _roadmap: Roadmap
var _level_tree: LevelTree
var _first_level_node: LevelTree.LevelNode

@export var _icons_container: Node
@export var _lines_container: Node
@export var _roadmap_camera: RoadmapCamera

#endregion


#region builtins

func _ready() -> void:
	if _roadmap:
		_level_tree = _roadmap.get_level_tree()
		_level_tree.node_added.connect(_on_node_added)
		
		_draw_existing_nodes()

#endregion


#region public

func zoom_to_first_level_node() -> void:
	var first_level_node = _find_first_level_node()
	if !first_level_node:
		return
	
	var node_position = first_level_node.get_position()
	await _roadmap_camera.do_zoom_in(node_position)

#endregion


#region private

func _draw_existing_nodes() -> void:
	var root = _level_tree.get_root()
	if root:
		_draw_node_and_children(root, null)


func _draw_node_and_children(node: LevelTree.LevelNode, parent: LevelTree.LevelNode) -> void:
	_create_icon_for(node)
	if parent:
		_create_line_between(node, parent)
	
	for child in node.get_children():
		_draw_node_and_children(child, node)


func _find_first_level_node() -> LevelTree.LevelNode:
	var root = _level_tree.get_root()
	if root:
		return _find_unlocked_node_recursive(root)
	return null


func _find_unlocked_node_recursive(node: LevelTree.LevelNode) -> LevelTree.LevelNode:
	if node.is_unlocked() and !_first_level_node:
		return node
	
	for child in node.get_children():
		var found = _find_unlocked_node_recursive(child)
		if found:
			return found
	
	return null


func _create_icon_for(node: LevelTree.LevelNode) -> void:
	var level_icon = LevelIcon.of(node)

	var node_position = node.get_position()
	level_icon.position = node_position
	level_icon.clicked.connect(_on_icon_clicked.bind(level_icon))

	_icons_container.add_child(level_icon)


func _create_line_between(node: LevelTree.LevelNode, parent: LevelTree.LevelNode) -> void:
	var level_line = LevelLine.between(node, parent)
	_lines_container.add_child(level_line)

#endregion


#region event handlers

func _on_node_added(node: LevelTree.LevelNode, parent: LevelTree.LevelNode) -> void:
	_create_icon_for(node)
	if parent:
		_create_line_between(node, parent)

func _on_icon_clicked(icon: LevelIcon) -> void:
	icon_selected.emit(icon)

#endregion


#region static

static func of(roadmap: Roadmap) -> RoadmapScene:
	var roadmap_scene = Registry.instantiate(Id.of_game("scenes.ui.roadmap", "RoadmapScene")) as RoadmapScene
	roadmap_scene._roadmap = roadmap
	return roadmap_scene

#endregion
