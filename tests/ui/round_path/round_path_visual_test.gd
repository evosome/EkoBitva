extends Control


#region constants

const TEST_ROUND_SEQUENCE = preload("res://resources/round_sequencers/test_sequence.tres")

#endregion


#region builtins

func _ready() -> void:
	var round_path = RoundPath.new(TEST_ROUND_SEQUENCE)
	var round_path_ui = RoundPathUI.of(round_path)
	add_child(round_path_ui)

	var new_round = round_path.get_next()
	new_round.start()
	new_round.__force_over()

#endregion
