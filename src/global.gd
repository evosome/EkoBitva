extends Node


#region public

func create_timer() -> Timer:
	var timer = Timer.new()
	add_child(timer)
	return timer

#endregion
