## Presenter of the developer message screen. The only thing it does is
## starting the new game roadmap generation when the player continues.
class_name DeveloperMessageScreen extends Screen


#region fields

@export var continue_button: Button

var _game: GameContext

#endregion


#region builtins

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)

#endregion


#region screen

func on_enter(ctx) -> void:
	_game = ctx.game


func on_exit() -> void:
	pass

#endregion


#region event handlers

func _on_continue_button_pressed() -> void:
	_game.navigation.switch_to("RoadmapGenerationScreen", Screen.Context.new(_game))

#endregion
