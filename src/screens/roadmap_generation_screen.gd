class_name RoadmapGenerationScreen extends Screen


#region constants

#FIXME - character should be selected in special screen
const BERG_CHARACTER = preload("res://resources/character_types/berg_character_type.tres")

#endregion


#region fields

@export var _animation_player: AnimationPlayer

#endregion


#region overrides

func on_enter(ctx: Context) -> void:
	var roadmap_generation_info = ctx.roadmap_generation_info
	if !roadmap_generation_info:
		push_error("Entered screen, but `roadmap_generation_info` was not set in context")
		return
	
	var roadmap_info = roadmap_generation_info.roadmap_info
	var roadmap = Roadmap.of(roadmap_info)

	var generator = roadmap_generation_info.roadmap_generator
	var max_depth = roadmap_generation_info.roadmap_depth
	generator.generate(max_depth, roadmap)

	_animation_player.play("loading_anim")
	await _animation_player.animation_finished
	
	var level_selection_screen = Registry.instantiate(Id.of_game("scenes.screens", "LevelSelectionScreen"))
	
	var context = LevelSelectionScreen.Context.new()
	context.roadmap = roadmap
	context.player_data = PlayerInfo.new(BERG_CHARACTER)
	
	switch_to(level_selection_screen, context)


func on_exit() -> void:
	return

#endregion


#region inner classes

class Context:
	var roadmap_generation_info: RoadmapGenerationInfo

#endregion
