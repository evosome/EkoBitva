extends Node


#region constants

const LOADING_SCREEN = preload("uid://cw5wch80c5jxi")

#endregion


func _ready() -> void:
	var loading_screen = LOADING_SCREEN.instantiate()
	loading_screen.enter(self)
