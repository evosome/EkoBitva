class_name PlayerInfo


#region fields

var _inventory: Inventory
var _character_type: CharacterType

#endregion


#region builtins

func _init(character_type: CharacterType) -> void:
	_inventory = Inventory.new()
	_character_type = character_type

#endregion


#region getters/setters

func get_character_type() -> CharacterType:
	return _character_type


func get_inventory() -> Inventory:
	return _inventory

#endregion
