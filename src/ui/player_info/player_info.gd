class_name PlayerInfoUI extends Control


#region fields

var _player_info: PlayerInfo

@export var _inventory_ui_container: Control
@export var _fishtiary_ui_container: Control
@export var character_name_label: Label
@export var character_icon_texture_rect: TextureRect

#endregion


#region builtins

func _ready() -> void:
	var inventory = _player_info.get_inventory()
	var inventory_ui = InventoryUI.of(inventory)
	_inventory_ui_container.add_child(inventory_ui)

	var fishtiary = _player_info.get_fishtiary()
	var fishtiart_ui = FishtiaryUI.of(fishtiary)
	_fishtiary_ui_container.add_child(fishtiart_ui)

	var character_type = _player_info.get_character_type()

	var character_name = character_type.name
	_set_character_name(character_name)

	var character_icon = character_type.icon
	_set_character_icon(character_icon)

#endregion


#region private

func _set_character_name(name: String) -> void:
	if character_name_label:
		character_name_label.text = name

func _set_character_icon(icon: Texture2D) -> void:
	if character_icon_texture_rect:
		character_icon_texture_rect.texture = icon

#endregion


#region static

static func of(player_info: PlayerInfo) -> PlayerInfoUI:
	var player_info_ui = Registry.instantiate(Id.of_game("scenes.ui.player_info", "PlayerInfo")) as PlayerInfoUI
	player_info_ui._player_info = player_info
	return player_info_ui

#endregion
