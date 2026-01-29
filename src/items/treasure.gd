class_name Treasure


#region fields

var _gold: int = 0
var _items: Array[Accessory]

#endregion


#region builtins

func _init(gold: int, items: Array[Accessory]):
	_gold = gold
	_items = items


func _to_string() -> String:
	return "Treasure(gold={gold}, items_amount={items_amount})".format({
		gold = _gold,
		items_amount = _items.size()
	})

#endregion


#region getters/setters

func get_gold() -> int:
	return _gold


func get_items() -> Array[Accessory]:
	return _items

#endregion
