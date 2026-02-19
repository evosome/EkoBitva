extends Control


#region constants

const TEST_ROUND_SEQUENCE = preload("res://resources/round_sequencers/test_sequence.tres")

#endregion


#region fields

var _round_path: RoundPath

@export var _timer: Timer

#endregion


#region builtins

func _ready() -> void:
	pass

# 	#var test_arena = Arena.make()

# 	_round_path = RoundPath.new(TEST_ROUND_SEQUENCE, null)
	
# 	var round_path_ui = RoundPathUI.of(_round_path)
# 	add_child(round_path_ui)

# 	_timer.timeout.connect(_on_timeout)

# #endregion


# #region event handlers

# func _on_timeout() -> void:
	
# 	if !_round_path.has_next():
# 		_timer.timeout.disconnect(_on_timeout)
# 		return
	
# 	var next_round = _round_path.get_next()
# 	next_round.__force_over()

#endregion
