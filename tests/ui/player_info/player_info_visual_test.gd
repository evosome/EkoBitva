extends Control


#region constants

const BERG_CHARACTER = preload("res://resources/character_types/berg_character_type.tres")
const BERG_GOBY_FISH_TYPE = preload("res://resources/fish_types/berg_goby_fish.tres")
const TEST_ITEM_TYPE = preload("res://resources/items/types/icebox.tres")

#endregion


#region fields

@export var _player_info_container: Control

#endregion


#region builtins

func _ready() -> void:
	var player_info = PlayerInfo.new(BERG_CHARACTER)
	var player_info_ui = PlayerInfoUI.of(player_info)
	_player_info_container.add_child(player_info_ui)
	
	var player_inventory = player_info.get_inventory()
	var accessory = Accessory.of(TEST_ITEM_TYPE)
	player_inventory.push(accessory)
	
	var fishtiary = player_info.get_fishtiary()
	var fish_entry = fishtiary.get_entry(BERG_GOBY_FISH_TYPE)
	fish_entry.unlock()

#endregion
