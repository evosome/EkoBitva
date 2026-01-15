class_name Inventory


#region constants

const DEFAULT_SIZE = 128

#endregion


#region signals

signal accessory_removed(accessory: Accessory, index: int)
signal accessory_added(accessory: Accessory, index: int)

#endregion


#region fields

var _size: int
var _item_array: Array[Accessory]
var _space_remaining: int

#endregion


#region builtins

func _init(size: int = DEFAULT_SIZE) -> void:
	_item_array = []
	_item_array.resize(size)
	_item_array.fill(null)
	_size = size
	_space_remaining = size

#endregion


#region getters/setters

func is_full() -> bool:
	return _space_remaining == 0

#endregion


#region public

func add(accessory: Accessory, index: int) -> bool:

	if !_can_add_at(index):
		return false

	_set_at(index, accessory)

	return true


func pop_at(index: int) -> Accessory:
	var item = _item_array[index]
	if item:
		_remove_at(index)
	return item


func push(accessory: Accessory) -> bool:
	var first_empty_index = _find_first_empty()

	if first_empty_index == -1:
		return false
	
	_set_at(first_empty_index, accessory)

	return true

#endregion


#region private

func _can_add_at(index: int) -> bool:
	var item = _item_array[index]
	return item == null


func _set_at(index: int, accessory: Accessory) -> void:
	_item_array[index] = accessory
	_space_remaining -= 1
	accessory_added.emit(accessory, index)


func _remove_at(index: int) -> void:
	var last_item = _item_array[index]
	_item_array[index] = null
	_space_remaining += 1
	accessory_removed.emit(last_item, index)


func _find_first_empty() -> int:
	var index = 0

	while index < _size && !_can_add_at(index):
		index += 1
	
	if index == _size:
		index = -1

	return index

#endregion
