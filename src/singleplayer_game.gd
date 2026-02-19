extends Node


func _ready() -> void:
	var loading_screen = Registry.instantiate(Id.of_game("scenes.screens", "LoadingScreen"))
	loading_screen.enter(self)
