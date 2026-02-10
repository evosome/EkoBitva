class_name PlayerInfo


#region fields

var _inventory: Inventory

#endregion


#region builtins

func _init() -> void:
	_inventory = Inventory.new()

#endregion


#region getters/setters

func get_inventory() -> Inventory:
	return _inventory

#endregion
