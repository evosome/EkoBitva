class_name DeveloperMessageScreen extends Screen


#region constants

#FIXME - generation info should be read from question packs, loaded via our website
const TEST_GENERATION_INFO = preload("uid://cmwa7rcn5lud2")
const ROADMAP_GENERATION_SCREEN = preload("uid://c8rpkcufeoxri")

#endregion


#region fields

@export var continue_button: Button

#endregion


#region builtins

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)

#endregion


#region abstract

func on_enter(ctx) -> void:
	pass


func on_exit() -> void:
	pass

#endregion


#region private

func _on_continue_button_pressed() -> void:
	var roadmap_generation_screen = ROADMAP_GENERATION_SCREEN.instantiate()
	var context = RoadmapGenerationScreen.Context.new()
	context.roadmap_generation_info = TEST_GENERATION_INFO
	switch_to(roadmap_generation_screen, context)

#endregion
