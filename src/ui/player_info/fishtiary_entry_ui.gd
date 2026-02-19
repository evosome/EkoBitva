class_name FishtiaryEntryUI extends Control


#region constants

const FISHTIARY_ENTRY_UI_SCENE = preload("uid://bbhe4gh2sjtmh")

#endregion


#region constants

const UNLOCKED_COLOR = Color.WHITE
const LOCKED_COLOR = Color.BLACK
const LOCKED_LABEL_TEXT = "???"

#endregion


#region fields

var _entry: Fishtiary.Entry

@export var _icon_texture: TextureRect
@export var _name_label: Label

#endregion


#region builtins

func _ready() -> void:
	var fish_type = _entry.get_fish_type()
	
	_set_icon_texture(fish_type.icon)

	var is_fish_unlocked = _entry.is_unlocked()
	_set_name_label(fish_type.name if is_fish_unlocked else LOCKED_LABEL_TEXT)
	_set_modulation_by_unlock_status(is_fish_unlocked)
	
	_entry.unlocked.connect(_on_entry_unlocked, CONNECT_ONE_SHOT)

#endregion


#region private

func _set_icon_texture(value: Texture2D) -> void:
	_icon_texture.texture = value


func _set_name_label(value: String) -> void:
	_name_label.text = value


func _set_modulation_by_unlock_status(is_unlocked: bool) -> void:
	var color = LOCKED_COLOR
	if is_unlocked:
		color = UNLOCKED_COLOR
	modulate = color

func _on_entry_unlocked() -> void:
	var fish_type = _entry.get_fish_type()
	var fish_name = fish_type.name
	_set_name_label(fish_name)
	_set_modulation_by_unlock_status(true)

#endregion


#region static

static func of(entry: Fishtiary.Entry) -> FishtiaryEntryUI:
	var fishtiary_entry_ui = FISHTIARY_ENTRY_UI_SCENE.instantiate() as FishtiaryEntryUI
	fishtiary_entry_ui._entry = entry
	return fishtiary_entry_ui

#endregion
