## Presenter of the boot loading screen: plays the loading animation
## and asks `NavigationManager` to continue the game flow.
class_name LoadingScreen extends Screen


#region fields

@export var _animation_player: AnimationPlayer

#endregion


#region screen

func on_enter(ctx) -> void:
	_animation_player.play("loading_anim")
	await _animation_player.animation_finished
	ctx.game.navigation.switch_to("DeveloperMessageScreen", Screen.Context.new(ctx.game))


func on_exit() -> void:
	pass

#endregion
