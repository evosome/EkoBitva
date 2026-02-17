extends Control


#region constants

const BERG_CHARACTER = preload("res://resources/character_types/berg_character_type.tres")
const TEST_ROADMAP_INFO = preload("res://resources/roadmap/info/test_roadmap_info.tres")
const DEFAULT_GENERATOR = preload("res://resources/generators/default_generator.tres")

#endregion


#region builtins

func _ready() -> void:
	var level_selection_screen = Registry.instantiate(Id.of_game("scenes.screens", "LevelSelectionScreen")) as LevelSelectionScreen
	
	var context = LevelSelectionScreen.Context.new()
	
	var player_data = PlayerInfo.new(BERG_CHARACTER)
	context.player_data = player_data
	
	var roadmap = Roadmap.of(TEST_ROADMAP_INFO)
	context.roadmap = roadmap
	level_selection_screen.enter(self, context)

	DEFAULT_GENERATOR.generate(8, roadmap)

#endregion
