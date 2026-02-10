extends Control


#region constants

const TEST_ROADMAP_INFO = preload("res://resources/roadmap/info/test_roadmap_info.tres")
const DEFAULT_GENERATOR = preload("res://resources/generators/default_generator.tres")

#endregion


#region builtins

func _ready() -> void:
	var level_selection_screen = Registry.instantiate(Id.of_game("scenes.screens", "LevelSelectionScreen")) as LevelSelectionScreen
	
	var context = LevelSelectionScreen.Context.new()
	context.player_data = PlayerInfo.new()
	
	var roadmap = Roadmap.of(TEST_ROADMAP_INFO)
	context.roadmap = roadmap
	level_selection_screen.enter(self, context)

	DEFAULT_GENERATOR.generate(8, roadmap)

#endregion
