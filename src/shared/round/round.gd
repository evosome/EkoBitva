class_name Round extends RefCounted


#region constants

const MIN_LOOT_AMOUNT = 0
const MAX_LOOT_AMOUNT = 2

#endregion


#region fields

var _type: RoundType
var _tier: int
var _enemy_character: Character

#endregion


#region builtins

func _init(info: RoundType, tier: int, enemy_character: Character) -> void:
	_type = info
	_tier = tier
	_enemy_character = enemy_character

#endregion


#region getters/setters

func get_type() -> RoundType:
	return _type


func get_tier() -> int:
	return _tier

func get_enemy_character() -> Character:
	return _enemy_character

#endregion
