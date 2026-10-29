## Presenter of the new game generation screen. It starts the session
## through `SessionManager` and just keeps the animation playing while
## the game world is being built.
class_name RoadmapGenerationScreen extends Screen


#region fields

@export var _animation_player: AnimationPlayer

#endregion


#region screen

func on_enter(ctx) -> void:

	_animation_player.play("loading_anim")

	ctx.game.session.start_new_game()

	await _animation_player.animation_finished
	ctx.game.navigation.switch_to("LevelSelectionScreen", Screen.Context.new(ctx.game))


func on_exit() -> void:
	pass

#endregion
