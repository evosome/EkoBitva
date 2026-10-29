## Passive view of the player inventory: a grid of `ItemCellUI`.
## The presenter fills cells with view data and keeps them in sync.
class_name InventoryUI extends Control


#region constants

const INVENTORY_UI_SCENE = preload("uid://bq17lx2juymgh")

#endregion


#region fields

@export var _item_cell_container: Control

#endregion


#region public (presenter-facing)

## Ensures that the grid contains exactly `amount` empty cells.
func fill_slots(amount: int) -> void:

	var current_amount = _item_cell_container.get_child_count()

	while current_amount < amount:
		_item_cell_container.add_child(ItemCellUI.empty())
		current_amount += 1

	while current_amount > amount:
		var last = _item_cell_container.get_child(current_amount - 1)
		_item_cell_container.remove_child(last)
		last.queue_free()
		current_amount -= 1


func get_slots() -> int:
	return _item_cell_container.get_child_count()


## Shows the item at the `index` slot.
func set_item(index: int, data: ItemViewData) -> void:
	var item_cell = _cell_at(index)
	if item_cell:
		item_cell.set_item(data)


## Empties the `index` slot.
func clear_item(index: int) -> void:
	var item_cell = _cell_at(index)
	if item_cell:
		item_cell.reset()

#endregion


#region private

func _cell_at(index: int) -> ItemCellUI:

	if index < 0 or index >= get_slots():
		push_warning("There is no inventory cell at index: ", index)
		return null

	return _item_cell_container.get_child(index) as ItemCellUI

#endregion


#region static

static func make() -> InventoryUI:
	return INVENTORY_UI_SCENE.instantiate() as InventoryUI

#endregion
