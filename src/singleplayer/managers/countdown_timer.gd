## Plain seconds-based countdown used by `BattleManager`.
## It is a manager-side service: the model knows nothing about timers.
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


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE and _timer:
		_timer.queue_free()

#endregion


#region getters/setters

func get_duration() -> int:
	return _duration


func get_remaining() -> int:
	return _remaining


func is_running() -> bool:
	return _remaining > 0

#endregion


#region public

func start() -> void:
	_timer.start()
	tick.emit(_remaining)


func stop() -> void:

	if !_timer:
		return

	_timer.stop()
	_timer.timeout.disconnect(_on_timer_timeout)
	_timer.queue_free()
	_timer = null

	_remaining = 0
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
