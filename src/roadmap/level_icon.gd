class_name LevelIcon extends Node2D


#region constants

## Modulation color of level icon, when the level is locked
const DEFAULT_LOCKED_MODCOLOR = Color.DARK_GRAY

## Modulation color of level icon, when the level is unlocked
const DEFAULT_UNLOCKED_MODCOLOR = Color.GREEN

## Modulation color of level icon, when the level is passed
const DEFAULT_PASSED_MODCOLOR = Color.WHITE

#endregion


#region fields

var _level_node: LevelTree.LevelNode

@export var _sprite: Sprite2D
@export var _ring_sprite: Sprite2D

#endregion


#region builtins

func _ready() -> void:

	var level = _level_node.get_level()

	var level_info = level.get_info()
	var level_icon_texture = level_info.roadmap_icon
	_sprite.texture = level_icon_texture

	var node_state = _level_node.get_state()
	_set_color_by_state(node_state)

	_level_node.state_changed.connect(_on_node_state_changed)

#endregion


#region private

func _set_color_by_state(state: LevelTree.NodeStates) -> void:
	var icon_color
	var ring_color
	match state:
		LevelTree.NodeStates.UNLOCKED:
			ring_color = DEFAULT_UNLOCKED_MODCOLOR
			icon_color = DEFAULT_PASSED_MODCOLOR
		LevelTree.NodeStates.PASSED:
			ring_color = DEFAULT_PASSED_MODCOLOR
			icon_color = DEFAULT_PASSED_MODCOLOR
		_:
			icon_color = DEFAULT_LOCKED_MODCOLOR
			ring_color = DEFAULT_LOCKED_MODCOLOR
	_sprite.modulate = icon_color
	_ring_sprite.modulate = ring_color

#endregion


#region event handlers

func _on_node_state_changed(state: LevelTree.NodeStates) -> void:
	_set_color_by_state(state)

#endregion


#region static

static func of(level_node: LevelTree.LevelNode) -> LevelIcon:
	#FIXME: remove preloading with `preload` method with `Registry.get_one()`
	var level_icon = preload("res://scenes/roadmap/level_icon.tscn").instantiate() as LevelIcon
	level_icon._level_node = level_node
	return level_icon

#endregion
