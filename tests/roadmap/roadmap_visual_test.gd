extends Node2D


#region constants

const TEST_GENERATOR = preload("res://resources/generators/default_generator.tres")
const TEST_ROADMAP_INFO = preload("res://resources/roadmap/info/test_roadmap_info.tres")

#endregion


#region builtins

func _ready() -> void:
	var roadmap = Roadmap.of(TEST_ROADMAP_INFO)
	add_child(roadmap)
	TEST_GENERATOR.generate(roadmap)

	# unlock and pass some first levels
	var level_tree = roadmap.get_level_tree()
	level_tree.get_root().pass_()
	level_tree.get_root().get_children()[0].pass_()

#endregion
