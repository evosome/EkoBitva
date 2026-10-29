## Passive view of a single roadmap level icon.
## The presenter pushes display data and receives the `clicked` event.
class_name LevelIcon extends Node2D


#region constants

const LEVEL_ICON_SCENE = preload("uid://cavy8aaomojf3")

## Modulation color of level icon, when the level is locked
const DEFAULT_LOCKED_MODCOLOR = Color.DARK_GRAY

## Modulation color of level icon, when the level is unlocked
const DEFAULT_UNLOCKED_MODCOLOR = Color.GREEN

## Modulation color of level icon, when the level is passed
const DEFAULT_PASSED_MODCOLOR = Color.WHITE

#endregion


#region signals

signal clicked()

#endregion


#region fields

var _id: StringName = &""
var _pending_icon: Texture2D
var _pending_state: LevelNodeViewData.State = LevelNodeViewData.State.LOCKED

@export var _sprite: Sprite2D
@export var _ring_sprite: Sprite2D
@export var _area2d: Area2D

#endregion


#region builtins

func _ready() -> void:
	_area2d.input_event.connect(_on_input_event)

	if _pending_icon:
		set_icon(_pending_icon)

	set_state(_pending_state)

#endregion


#region getters/setters (presenter-facing)

func get_id() -> StringName:
	return _id


func set_icon(value: Texture2D) -> void:
	_pending_icon = value
	_sprite.texture = value


func set_state(state: LevelNodeViewData.State) -> void:
	_pending_state = state
	_set_color_by_state(state)

#endregion


#region private

func _set_color_by_state(state: LevelNodeViewData.State) -> void:
	var icon_color
	var ring_color
	match state:
		LevelNodeViewData.State.UNLOCKED:
			ring_color = DEFAULT_UNLOCKED_MODCOLOR
			icon_color = DEFAULT_PASSED_MODCOLOR
		LevelNodeViewData.State.PASSED:
			ring_color = DEFAULT_PASSED_MODCOLOR
			icon_color = DEFAULT_PASSED_MODCOLOR
		_:
			icon_color = DEFAULT_LOCKED_MODCOLOR
			ring_color = DEFAULT_LOCKED_MODCOLOR
	_sprite.modulate = icon_color
	_ring_sprite.modulate = ring_color

#endregion


#region event handlers

func _on_input_event(_viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit()

#endregion


#region static

static func of(data: LevelNodeViewData) -> LevelIcon:
	var level_icon = LEVEL_ICON_SCENE.instantiate() as LevelIcon
	level_icon._id = data.id
	level_icon.position = data.position
	level_icon._pending_icon = data.icon
	level_icon._pending_state = data.state
	return level_icon

#endregion
