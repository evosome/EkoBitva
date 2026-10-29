## Passive view of the treasure bag: gold amount and the last loot items carousel.
class_name TreasureBagUI extends Control


#region constants

const DEFAULT_VISIBLE_SIZE = 4

const TREASURE_BAG_UI_SCENE = preload("uid://b0bx71475ou2i")

#endregion


#region fields

var _gold_amount: int = 0
var _period_value: int = 0
var _item_queue: Array[ItemViewData] = []

@export var _gold_label: Label
@export var _period_label: Label
@export var _treasure_list: Control
@export var _period_container: Control

#endregion


#region builtins

func _ready() -> void:
	_set_period_visible(false)
	_set_gold_text(_gold_amount)

#endregion


#region public (presenter-facing)

## Sets the absolute gold amount shown on the badge.
func set_gold(amount: int) -> void:
	_gold_amount = amount
	_set_gold_text(_gold_amount)


## Pushes newly found items into the visible carousel.
func add_items(items: Array[ItemViewData]) -> void:

	if items.is_empty():
		return

	for item in items:
		_item_queue.push_front(item)
		if _item_queue.size() > DEFAULT_VISIBLE_SIZE:
			_item_queue.pop_back()

			_period_value += 1
			_set_period_text(_period_value)
			_set_period_visible(true)

	_update_treasure_list()

#endregion


#region private

func _set_gold_text(value: int) -> void:
	_gold_label.text = String.num_int64(value)


func _set_period_text(value: int) -> void:
	_period_label.text = String.num_int64(value)


func _set_period_visible(value: bool) -> void:
	_period_container.visible = value


func _update_treasure_list() -> void:
	for i in range(0, _item_queue.size()):
		var item = _item_queue[i]
		var item_cell = _treasure_list.get_child(i) as ItemCellUI
		item_cell.set_item(item)

#endregion


#region static

static func make() -> TreasureBagUI:
	return TREASURE_BAG_UI_SCENE.instantiate() as TreasureBagUI

#endregion
