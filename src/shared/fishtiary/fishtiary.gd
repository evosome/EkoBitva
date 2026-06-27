class_name Fishtiary


#region signals

signal entry_unlocked(entry: Entry)

#endregion


#region fields

var _entries: Dictionary[FishType, Entry]

#endregion


#region builtins

func _init(fish_types: Array[FishType]) -> void:
	_entries = {}
	_populate_entries(fish_types)

#endregion


#region public

func unlock_entry(fish_type: FishType) -> void:
	var entry = _get_entry(fish_type)
	var is_unlocked = entry.is_unlocked()
	if is_unlocked:
		push_warning("Entry for fish type: {fish_type} has been already unlocked".format({
			fish_type = fish_type
		}))
		return
	
	entry._is_unlocked = true
	entry_unlocked.emit(entry)


func get_entries() -> Array[Entry]:
	var entries: Array[Entry]
	var entries_values = _entries.values()
	entries.assign(entries_values)
	return entries

#endregion


#region private

func _get_entry(fish_type: FishType) -> Entry:
	if not _entries.has(fish_type):
		_entries[fish_type] = Entry.new(fish_type)
	return _entries[fish_type]


func _populate_entries(fish_types: Array[FishType]) -> void:
	for fish_type in fish_types:
			_entries[fish_type] = Entry.new(fish_type)

#endregion


#region inner classes

class Entry extends RefCounted:
	var _fish_type: FishType
	var _is_unlocked: bool = false

	func _init(fish_type: FishType) -> void:
		_fish_type = fish_type
	
	func is_unlocked() -> bool:
		return _is_unlocked

	func get_fish_type() -> FishType:
		return _fish_type

#endregion
