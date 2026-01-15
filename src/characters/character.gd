class_name Character extends Node2D


#region signals

signal died(cause)

#endregion


#region getters/setters

func get_buffs() -> Array[BuffType]:
	return []

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

#endregion


#region static

static func of(type: CharacterType) -> Character:
	return null

#endregion
