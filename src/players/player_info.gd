class_name PlayerInfo


#region fields

var _inventory: Inventory
var _character_type: CharacterType

#endregion


#region builtins

func _init() -> void:
	_inventory = Inventory.new()

#endregion


#region getters/setters

func get_inventory() -> Inventory:
	return _inventory


func get_character_type() -> CharacterType:
	return _character_type

#endregion
