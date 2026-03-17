class_name LoadingScreen extends Screen


#region constants

const DEVELOPER_MESSAGE_SCREEN = preload("uid://cl66q8u8pxhpn")

#endregion


#region fields

@export var _animation_player: AnimationPlayer

#endregion


#region overrides

func on_enter(ctx: Variant) -> void:
	_animation_player.play("loading_anim")
	await _animation_player.animation_finished
	var developer_message_screen = DEVELOPER_MESSAGE_SCREEN.instantiate()
	switch_to(developer_message_screen)


func on_exit() -> void:
	return

#endregion
