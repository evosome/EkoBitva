class_name LoadingScreen extends Screen


#region fields

@export var _animation_player: AnimationPlayer

#endregion


#region overrides

func on_enter(ctx: Variant) -> void:
	_animation_player.play("loading_anim")
	await _animation_player.animation_finished
	var developer_message_screen = Registry.instantiate(Id.of_game("scenes.screens", "DeveloperMessageScreen"))
	switch_to(developer_message_screen)


func on_exit() -> void:
	return

#endregion
