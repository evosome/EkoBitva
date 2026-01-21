## Entry class for singleplayer game
class_name SingleplayerGame extends Node


#region constants

var DEFAULT_STARTING_SCREEN_ID = Id.of_game("screens", "LastSaveLoadingScreen")
var CONTENT_LOADING_SCREEN_ID = Id.of_game("screens", "LoadingScreen")

#endregion


#region fields

@export var _screen_container: Control

@onready var _packed_default_starting_screen: PackedScene = Registry.get_one(DEFAULT_STARTING_SCREEN_ID)
@onready var _packed_loading_screen: PackedScene = Registry.get_one(CONTENT_LOADING_SCREEN_ID)

#endregion


#region builtins

func _ready() -> void:
	var loading_screen = _packed_loading_screen.instantiate() as Screen
	loading_screen.enter(_screen_container)

	await loading_screen.exited

	var starting_screen = _packed_default_starting_screen.instantiate() as Screen
	starting_screen.enter(_screen_container)

#endregion
