class_name PlayerInfoUI extends Control


#region fields

var _player_info: PlayerInfo

@export var _inventory_ui_container: Control
@export var _fishtiary_ui_container: Control

#endregion


#region builtins

func _ready() -> void:
	var inventory = _player_info.get_inventory()
	var inventory_ui = InventoryUI.of(inventory)
	_inventory_ui_container.add_child(inventory_ui)

	var fishtiary = _player_info.get_fishtiary()
	var fishtiart_ui = FishtiaryUI.of(fishtiary)
	_fishtiary_ui_container.add_child(fishtiart_ui)

#endregion


#region static

static func of(player_info: PlayerInfo) -> PlayerInfoUI:
	var player_info_ui = Registry.instantiate(Id.of_game("scenes.ui.player_info", "PlayerInfo")) as PlayerInfoUI
	player_info_ui._player_info = player_info
	return player_info_ui

#endregion
