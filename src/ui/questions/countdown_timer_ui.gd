## Passive view of the question countdown.
## Only the presenter pushes display data here.
class_name CountdownTimerUI extends Control


#region constants

const TIMER_RESET_LABEL = "00:00"
const TIMER_LABEL_PATTERN = "%02d:%02d"
const INFINITE_LABEL_PATTERN = "oo:oo"

#endregion


#region fields

@export var _label: Label

#endregion


#region builtins

func _ready() -> void:
	reset()

#endregion


#region public (presenter-facing)

## Shows remaining seconds. Negative value shows the `no timeout` label.
func set_remaining(seconds: int) -> void:
	_update_label(seconds)


## Shows that the question has no timeout at all.
func set_infinite() -> void:
	_update_label(-1)


## Returns label to the initial state.
func reset() -> void:
	_update_label(0)

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
