## Passive view of the roadmap canvas (icons + lines + camera).
## The presenter feeds it with `LevelNodeViewData` / `LevelLineViewData`
## and listens to the `icon_clicked` event.
class_name RoadmapScene extends Node2D


#region constants

const ROADMAP_SCENE_SCENE = preload("uid://lqe63xmn6gst")

#endregion


#region signals

signal icon_clicked(id: StringName)

#endregion


#region fields

var _icons: Dictionary[StringName, LevelIcon] = {}

@export var _icons_container: Node
@export var _lines_container: Node
@export var _roadmap_camera: RoadmapCamera

#endregion


#region public (presenter-facing)

## This method is asynchronous.
func zoom_to(position: Vector2) -> void:
	await _roadmap_camera.do_zoom_in(position)


func add_level_node(data: LevelNodeViewData) -> void:
	var level_icon = LevelIcon.of(data)
	level_icon.clicked.connect(_on_icon_clicked.bind(data.id))
	_icons[data.id] = level_icon
	_icons_container.add_child(level_icon)


func set_level_node_state(id: StringName, state: LevelNodeViewData.State) -> void:
	var level_icon = _icons.get(id)
	if !level_icon:
		push_warning("There is no level icon with id: ", id)
		return
	level_icon.set_state(state)


func add_level_line(data: LevelLineViewData) -> void:
	_lines_container.add_child(LevelLine.of(data))

#endregion


#region event handlers

func _on_icon_clicked(id: StringName) -> void:
	icon_clicked.emit(id)

#endregion


#region static

static func make() -> RoadmapScene:
	return ROADMAP_SCENE_SCENE.instantiate() as RoadmapScene

#endregion
