class_name Character extends Node2D


#region constants

const CHARACTER_SCENE = preload("uid://bbr4uyuuya63u")

#endregion


#region constants

const MAX_HEALTH_TIER_MULTIPLIER = 0.6

#endregion


#region signals

signal died()

#endregion


#region fields

var _type: CharacterType
var _current_tier: int

@export var _buff_component: BuffComponent
@export var _health_component: HealthComponent

#endregion


#region builtins

func _ready() -> void:
	var max_health = _health_component.get_max_health() * MAX_HEALTH_TIER_MULTIPLIER * _current_tier
	_health_component.set_max_health(max_health)
	_health_component.set_health(max_health)

	_health_component.died.connect(_on_health_ended)


func _to_string() -> String:
	return "Character(type={type})".format({
		type = _type
	})

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
	print_debug("Dealed {damage_amount} damage points to {character}. Remaining HP: {remains}".format({
		damage_amount = damage_amount,
		character = self,
		remains = _health_component.get_health()
	}))


func do_attack(character: Character) -> void:
	pass

#endregion


#region event handlers

func _on_health_ended() -> void:
	print_debug("Character {character} died".format({
		character = self
	}))
	died.emit()

#endregion


#region static

static func of(type: CharacterType, tier: int) -> Character:
	var character = CHARACTER_SCENE.instantiate() as Character
	character._type = type
	character._current_tier = tier
	return character

#endregion
