## Passive view of the fishtiary: a list of `FishtiaryEntryUI`.
class_name FishtiaryUI extends Control


#region constants

const FISHTIARY_UI_SCENE = preload("uid://bo8xv3kg3xkno")

#endregion


#region fields

var _entries: Dictionary[StringName, FishtiaryEntryUI] = {}

@export var _entries_container: Control

#endregion


#region public (presenter-facing)

func add_entry(data: FishEntryViewData) -> void:
	var entry_ui = FishtiaryEntryUI.of(data)
	_entries[data.id] = entry_ui
	_entries_container.add_child(entry_ui)


## Reveals the entry: shows the real fish name instead of the placeholder.
func set_entry_unlocked(id: StringName, display_name: String) -> void:
	var entry_ui = _entries.get(id)
	if !entry_ui:
		push_warning("There is no fishtiary entry with id: ", id)
		return
	entry_ui.set_unlocked(display_name)

#endregion


#region static

static func make() -> FishtiaryUI:
	return FISHTIARY_UI_SCENE.instantiate() as FishtiaryUI

#endregion
