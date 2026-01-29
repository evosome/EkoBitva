class_name TreasureBagUI extends Control


#region constants

const DEFAULT_VISIBLE_SIZE = 4

#endregion


#region fields

var _gold_amount: int = 0
var _period_value: int = 0
var _item_queue: Array[Accessory]
var _treasure_bag: TreasureBag

@export var _gold_label: Label
@export var _period_label: Label
@export var _treasure_list: Control
@export var _period_container: Control

#endregion


#region builtins

func _ready() -> void:

	_set_period_visible(false)

	var items = _treasure_bag.get_items()
	_add_items(items)

	_treasure_bag.treasure_added.connect(_on_treasure_added)

#endregion


#region private

func _set_gold_text(value: int) -> void:
	_gold_label.text = String.num_int64(value)


func _set_period_text(value: int) -> void:
	_period_label.text = String.num_int64(value)


func _set_period_visible(value: bool) -> void:
	_period_container.visible = value


func _add_gold(gold: int) -> void:
	_gold_amount += gold
	_set_gold_text(_gold_amount)


func _add_items(items: Array[Accessory]) -> void:
	var items_amount = items.size()

	if items_amount == 0:
		return
		
	
	var min_end_index = min(items_amount, DEFAULT_VISIBLE_SIZE)
	var items_to_render = items.slice(0, min_end_index)

	for item in items_to_render:
		_item_queue.push_front(item)
		if _item_queue.size() > DEFAULT_VISIBLE_SIZE:
			_item_queue.pop_back()
			
			_period_value += 1
			_set_period_text(_period_value)
			_set_period_visible(true)
	
	_update_treasure_list()


func _update_treasure_list() -> void:
	for i in range(0, _item_queue.size()):
		var item = _item_queue[i]
		var item_cell = _treasure_list.get_child(i) as ItemCellUI
		item_cell.wrap_item(item)

#endregion


#region event handlers

func _on_treasure_added(treasure: Treasure) -> void:
	var items = treasure.get_items()
	_add_items(items)

	var gold = treasure.get_gold()
	_add_gold(gold)

#endregion


#region static

static func of(treasure_bag: TreasureBag) -> TreasureBagUI:
	var treasure_bag_ui = Registry.instantiate(Id.of_game("scenes.ui.treasure", "TreasureBagUI")) as TreasureBagUI
	treasure_bag_ui._treasure_bag = treasure_bag
	return treasure_bag_ui

#endregion
