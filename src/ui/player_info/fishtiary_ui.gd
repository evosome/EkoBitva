class_name FishtiaryUI extends Control


#region constants

const FISHTIARY_UI_SCENE = preload("uid://bo8xv3kg3xkno")

#endregion


#region fields

var _fishtiary: Fishtiary

@export var _entries_container: Control

#endregion


#region builtins

func _ready() -> void:
    _setup_entries()

#endregion


#region private

func _setup_entries() -> void:

    for child in _entries_container.get_children():
        _entries_container.remove_child(child)

    var entries = _fishtiary.get_entries()
    for entry in entries:
        var entry_ui = FishtiaryEntryUI.of(entry)
        _entries_container.add_child(entry_ui)

#endregion


#region static

static func of(fishtiary: Fishtiary) -> FishtiaryUI:
    var fishtiary_ui = FISHTIARY_UI_SCENE.instantiate() as FishtiaryUI
    fishtiary_ui._fishtiary = fishtiary
    return fishtiary_ui

#endregion
