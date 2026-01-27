class_name Character extends Node2D


#region signals

signal died()

#endregion


#region fields

var _type: CharacterType

@export var _buff_component: BuffComponent
@export var _health_component: HealthComponent

#endregion


#region getters/setters

func get_buffs() -> Array[BuffType]:
	return []


func get_health() -> HealthComponent:
	return _health_component

#endregion


#region public

func add_buff(buff: BuffType) -> void:
	pass


func remove_buff(buff: BuffType) -> void:
	pass


func spawn_on(arena: Arena) -> void:
	pass


func despawn() -> void:
	pass


## This method is asynchronous.
func do_damage(damage_info: DamageInfo) -> void:
	var damage_amount = damage_info.get_amount()
	_health_component.withdraw(damage_amount)


func do_attack(character: Character) -> void:
	pass

#endregion


#region static

static func of(type: CharacterType) -> Character:
	return null

#endregion
