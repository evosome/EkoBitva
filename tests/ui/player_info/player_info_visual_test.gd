extends Control


#region constants

const TEST_ITEM_TYPE = preload("res://resources/items/types/icebox.tres")

#endregion


#region builtins

func _ready() -> void:
	var player_info = PlayerInfo.new()
	var player_info_ui = PlayerInfoUI.of(player_info)
	add_child(player_info_ui)
	
	var player_inventory = player_info.get_inventory()
	var accessory = Accessory.of(TEST_ITEM_TYPE)
	player_inventory.push(accessory)

#endregion
