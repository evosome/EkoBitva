class_name CountdownTimerUI extends Control


#region constants

const TIMER_RESET_LABEL = "00:00"
const TIMER_LABEL_PATTERN = "%02d:%02d"
const INFINITE_LABEL_PATTERN = "oo:oo"

#endregion


#region fields

var _timer: CountdownTimer

@export var _label: Label

#endregion


#region builtins

func _ready() -> void:
	_update_label(0)

#endregion


#region public

func wrap_timer(countdown_timer: CountdownTimer) -> void:

	if _timer:
		push_error("CountdownTimerUI already wrapping countdown timer. Stop it, to wrap other one")
		return
	
	if !countdown_timer:
		_update_label(-1)
		return

	_timer = countdown_timer
	_timer.tick.connect(_on_tick)
	_timer.timeout.connect(_on_timeout)


func make_infinite() -> void:
	wrap_timer(null)

#endregion


#region private

func _update_label(seconds: int) -> void:

	if seconds < 0:
		_label.text = INFINITE_LABEL_PATTERN
		return

	if seconds == 0:
		_label.text = TIMER_RESET_LABEL
		return

	var minutes = seconds / 60
	var remaining_seconds = seconds % 60
	_label.text = TIMER_LABEL_PATTERN % [minutes, remaining_seconds]

#endregion


#region event handlers

func _on_tick(seconds: int) -> void:
	_update_label(seconds)


func _on_timeout() -> void:
	_timer = null
	_timer.tick.disconnect(_on_tick)
	_timer.timeout.disconnect(_on_timeout)
	_update_label(0)

#endregion
