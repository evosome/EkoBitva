## Passive view of a single fishtiary entry.
class_name FishtiaryEntryUI extends Control


#region constants

const FISHTIARY_ENTRY_UI_SCENE = preload("uid://bbhe4gh2sjtmh")

const UNLOCKED_COLOR = Color.WHITE
const LOCKED_COLOR = Color.BLACK
const LOCKED_LABEL_TEXT = "???"

#endregion


#region fields

var _id: StringName = &""
var _icon: Texture2D
var _display_name: String = ""
var _is_unlocked: bool = false

@export var _icon_texture: TextureRect
@export var _name_label: Label

#endregion


#region builtins

func _ready() -> void:
	_render()

#endregion


#region getters/setters (presenter-facing)

func get_id() -> StringName:
	return _id


func set_unlocked(display_name: String) -> void:
	_is_unlocked = true
	_display_name = display_name
	_render()

#endregion


#region private

func _render() -> void:
	_icon_texture.texture = _icon
	_name_label.text = _display_name if _is_unlocked else LOCKED_LABEL_TEXT
	modulate = UNLOCKED_COLOR if _is_unlocked else LOCKED_COLOR

#endregion


#region static

static func of(data: FishEntryViewData) -> FishtiaryEntryUI:
	var entry_ui = FISHTIARY_ENTRY_UI_SCENE.instantiate() as FishtiaryEntryUI
	entry_ui._id = data.id
	entry_ui._icon = data.icon
	entry_ui._display_name = data.display_name
	entry_ui._is_unlocked = data.is_unlocked
	return entry_ui

#endregion
