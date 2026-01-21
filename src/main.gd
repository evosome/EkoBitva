extends Node


#region constants

const SINGLEPLAYER_CORE = preload("res://scenes/singleplayer_game.tscn")

#endregion


#region builtins

func _ready() -> void:
	var core_instance = SINGLEPLAYER_CORE.instantiate()
	add_child(core_instance)

#endregion
