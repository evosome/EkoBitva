## View-layer data holder describing a single fishtiary entry.
class_name FishEntryViewData extends RefCounted


#region fields

var id: StringName
var icon: Texture2D
var display_name: String
var is_unlocked: bool = false

#endregion


#region static

static func of(id: StringName, icon: Texture2D, display_name: String, is_unlocked: bool = false) -> FishEntryViewData:
	var data = FishEntryViewData.new()
	data.id = id
	data.icon = icon
	data.display_name = display_name
	data.is_unlocked = is_unlocked
	return data

#endregion
