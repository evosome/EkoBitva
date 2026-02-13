class_name CountdownTimer extends RefCounted


#region signals

signal tick(seconds: int)
signal timeout()
signal stopped()

#endregion


#region fields

var _duration: int = 0
var _remaining: int = 0
var _timer: Timer

#endregion


#region builtins

func _init(duration: int) -> void:

	_duration = duration
	_remaining = duration

	_timer = Global.create_timer()
	_timer.wait_time = 1.0
	_timer.timeout.connect(_on_timer_timeout)

#endregion


#region getters/setters

func get_duration() -> int:
	return _duration


func get_remaining() -> int:
	return _remaining


func is_running() -> bool:
	return _remaining > 0

#endregion


#region private

func start() -> void:
	_timer.start()
	tick.emit(_remaining)


func stop() -> void:
	_timer.stop()
	_remaining = 0
	_timer.queue_free()
	_timer.timeout.disconnect(_on_timer_timeout)
	stopped.emit()

#endregion


#region event handlers

func _on_timer_timeout() -> void:
	_remaining -= 1
	if _remaining > 0:
		tick.emit(_remaining)
	else:
		stop()
		timeout.emit()

#endregion
