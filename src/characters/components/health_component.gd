class_name HealthComponent extends Node


#region signals

signal died()
signal health_changed(value: int)

#endregion


#region fields

var _health_amount: int
var _max_health: int

@export var _initial_max_health: int = 100

#endregion


#region built-in

func _ready() -> void:
	_max_health = _initial_max_health
	_health_amount = _max_health

#endregion


#region getters/setters

func get_health() -> int:
	return _health_amount


func set_health(value: int) -> void:
	if value > _max_health:
		push_warning("Max health is: ", _max_health, ", but tried to set higher value: ", value)
	if value < 0:
		push_warning("Health cannot be negative value!")
	_health_amount = clamp(value, 0, _max_health)
	health_changed.emit(value)
	
	if _health_amount == 0:
		died.emit()


func get_max_health() -> int:
	return _max_health

#endregion


#region public

func withdraw(amount: int) -> void:
	var health_withdraw = clamp(amount, 0, _health_amount)
	_health_amount -= health_withdraw

#endregion
