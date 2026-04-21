class_name TreasureBag extends RefCounted


#region signals

signal treasure_added(treasure: Treasure)

#endregion


#region fields

var _items: Array[Accessory] = []
var _total_gold: int = 0

#endregion


#region getters/setters

func get_items() -> Array[Accessory]:
	return _items

func get_total_gold() -> int:
	return _total_gold

#endregion


#region public

func add(treasure: Treasure) -> void:
	var treashure_items = treasure.get_items()
	_items.append_array(treashure_items)

	var treasure_gold = treasure.get_gold()
	_total_gold += treasure_gold

	treasure_added.emit(treasure)

#endregion
