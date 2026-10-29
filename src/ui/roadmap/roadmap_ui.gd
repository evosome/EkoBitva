## Passive facade over the roadmap canvas. It composes the inner
## `RoadmapScene` view and exposes a single API for the presenter.
class_name RoadmapUI extends Control


#region constants

const ROADMAP_UI_SCENE = preload("uid://lgo435hcs47b")

#endregion


#region signals

signal icon_selected(id: StringName)

#endregion


#region fields

var _roadmap_scene: RoadmapScene

@export var _viewport: SubViewport

#endregion


#region builtins

func _ready() -> void:
	_ensure_scene()

#endregion


#region public (presenter-facing)

## This method is asynchronous.
func zoom_to(position: Vector2) -> void:
	_ensure_scene()
	await _roadmap_scene.zoom_to(position)


func add_level_node(data: LevelNodeViewData) -> void:
	_ensure_scene()
	_roadmap_scene.add_level_node(data)


func set_level_node_state(id: StringName, state: LevelNodeViewData.State) -> void:
	_ensure_scene()
	_roadmap_scene.set_level_node_state(id, state)


func add_level_line(data: LevelLineViewData) -> void:
	_ensure_scene()
	_roadmap_scene.add_level_line(data)

#endregion


#region private

func _ensure_scene() -> void:
	if _roadmap_scene:
		return

	_roadmap_scene = RoadmapScene.make()
	_roadmap_scene.icon_clicked.connect(_on_icon_clicked)
	_viewport.add_child(_roadmap_scene)

#endregion


#region event handlers

func _on_icon_clicked(id: StringName) -> void:
	icon_selected.emit(id)

#endregion


#region static

static func make() -> RoadmapUI:
	return ROADMAP_UI_SCENE.instantiate() as RoadmapUI

#endregion
