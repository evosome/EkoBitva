extends Node


#region constants

const LOADING_SCREEN_NAME = "LoadingScreen"

#endregion


#region fields

var _context: GameContext

#endregion


#region builtins

func _ready() -> void:
	_context = GameContext.bootstrap(self)
	_context.navigation.switch_to(LOADING_SCREEN_NAME, Screen.Context.new(_context))

#endregion
