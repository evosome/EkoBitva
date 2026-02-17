class_name Character extends Node2D


#region signals

signal died()

#endregion


#region fields

var _type: CharacterType

@export var _buff_component: BuffComponent
@export var _health_component: HealthComponent

#endregion


#region builtins

func _ready() -> void:
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

static func of(type: CharacterType) -> Character:
	var character = Registry.instantiate(Id.of_game("scenes.characters", "Character")) as Character
	character._type = type
	return character

#endregion
