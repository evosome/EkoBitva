class_name InventoryUI extends Control


#region constants

const INVENTORY_UI_SCENE = preload("uid://bq17lx2juymgh")

#endregion


#region fields

var _inventory: Inventory

@export var _item_cell_container: Control

#endregion


#region builtins

func _ready() -> void:
	_clear_container()
	_setup_item_cells()

	_inventory.accessory_added.connect(_on_accessory_added)
	_inventory.accessory_removed.connect(_on_accessory_removed)


func _exit_tree() -> void:
	_inventory.accessory_added.disconnect(_on_accessory_added)
	_inventory.accessory_removed.disconnect(_on_accessory_removed)

#endregion


#region private

func _clear_container() -> void:
	for child in _item_cell_container.get_children():
		_item_cell_container.remove_child(child)


func _setup_item_cells() -> void:

	for i in range(Inventory.DEFAULT_SIZE):
		var item_cell = ItemCellUI.empty()
		_item_cell_container.add_child(item_cell)

	var accessories = _inventory.get_all()
	for i in range(accessories.size()):
		var item_cell = _item_cell_container.get_child(i) as ItemCellUI
		var accessory = accessories[i]
		item_cell.wrap_item(accessory)

#endregion


#region event handlers

func _on_accessory_added(accessory: Accessory, index: int) -> void:
	var item_cell = _item_cell_container.get_child(index) as ItemCellUI
	item_cell.wrap_item(accessory)


func _on_accessory_removed(_accessory: Accessory, index: int) -> void:
	var item_cell = _item_cell_container.get_child(index) as ItemCellUI
	item_cell.reset()

#endregion


#region public

static func of(inventory: Inventory) -> InventoryUI:
	var inventory_ui = INVENTORY_UI_SCENE.instantiate() as InventoryUI
	inventory_ui._inventory = inventory
	return inventory_ui

#endregion
