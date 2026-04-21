class_name Fishtiary


#region fields

var _entries: Dictionary

#endregion


#region builtins

func _init() -> void:
	_entries = {}
	_populate_entries()

#endregion


#region public

func get_entry(fish_type: FishType) -> Entry:
	if not _entries.has(fish_type):
		_entries[fish_type] = Entry.new(fish_type)
	return _entries[fish_type]


func get_entries() -> Array:
	return _entries.values()

#endregion


#region private

func _populate_entries() -> void:
	var fish_types = Registry.get_all("resources.fish_types")
	for fish_type in fish_types:
			_entries[fish_type] = Entry.new(fish_type)

#endregion


#region inner classes

class Entry extends RefCounted:

	signal unlocked()

	var _fish_type: FishType
	var _is_unlocked: bool = false

	func _init(fish_type: FishType) -> void:
		_fish_type = fish_type

	func unlock() -> void:
		_is_unlocked = true
		unlocked.emit()

	func can_unlock() -> bool:
		return not _is_unlocked
	
	func is_unlocked() -> bool:
		return _is_unlocked

	func get_fish_type() -> FishType:
		return _fish_type

#endregion
