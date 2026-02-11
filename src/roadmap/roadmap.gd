class_name Roadmap extends Node2D


#region signals

signal icon_selected(level_icon: LevelIcon)

#endregion


#region fields

var _info: RoadmapInfo
var _level_tree: LevelTree
var _level_type_pool: LevelTypePool
var _first_level_node: LevelTree.LevelNode

@export var _tilemap: TileMapLayer
@export var _icons_container: Node
@export var _lines_container: Node
@export var _roadmap_camera: RoadmapCamera

#endregion


#region builtins

func _ready() -> void:

	_level_type_pool = _info.level_type_pool

	_level_tree = LevelTree.new()
	_level_tree.node_added.connect(_on_node_added)

#endregion


#region getters/setters

func get_tilemap() -> TileMapLayer:
	return _tilemap


func get_level_tree() -> LevelTree:
	return _level_tree


func get_level_type_pool() -> LevelTypePool:
	return _level_type_pool

#endregion


#region private

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
	
	if !_first_level_node && node.is_unlocked():
		_first_level_node = node
		var node_position = node.get_position()
		_roadmap_camera.do_zoom_in(node_position)


func _on_icon_clicked(icon: LevelIcon) -> void:
	icon_selected.emit(icon)

#endregion


#region static

static func of(info: RoadmapInfo) -> Roadmap:
	var roadmap = Registry.instantiate(Id.of_game("scenes.roadmap", "Roadmap")) as Roadmap
	roadmap._info = info
	return roadmap

#endregion
