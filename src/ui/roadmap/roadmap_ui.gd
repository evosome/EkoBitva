class_name RoadmapUI extends Control


#region signals

signal icon_selected(level_icon: LevelIcon)

#endregion


#region fields

var _roadmap: Roadmap
var _roadmap_scene: RoadmapScene
var _roadmap_camera: RoadmapCamera

@export var _viewport: SubViewport

#endregion


#region builtins

func _ready() -> void:
	if _roadmap:
		_setup_roadmap_ui()

#endregion


#region private

func _setup_roadmap_ui() -> void:
	if _roadmap_scene:
		_roadmap_scene.queue_free()
	
	_roadmap_scene = RoadmapScene.of(_roadmap)
	_roadmap_scene.icon_selected.connect(_on_icon_selected)
	_viewport.add_child(_roadmap_scene)
	
	await _roadmap_scene.zoom_to_first_level_node()

#endregion


#region event handlers

func _on_icon_selected(icon: LevelIcon) -> void:
	icon_selected.emit(icon)

#endregion


#region static

static func of(roadmap: Roadmap) -> RoadmapUI:
	var roadmap_ui = Registry.instantiate(Id.of_game("scenes.ui.roadmap", "RoadmapUI")) as RoadmapUI
	roadmap_ui._roadmap = roadmap
	return roadmap_ui

#endregion
