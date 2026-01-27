class_name Arena extends Node2D


#region signals

## Fires, when any first (both player and enemy) character died
signal character_died(character: Character)

signal enemy_changed(character: Character)

#endregion


#region fields

var _info: ArenaInfo
var _is_purged: bool
var _current_player: PlayerInfo
var _enemy_character: Character
var _player_character: Character

#endregion


#region getters/setters

func is_purged() -> bool:
	return _is_purged


func get_info() -> ArenaInfo:
	return _info


func get_player_character() -> Character:
	return _player_character


## Replace previous character by a new one.
## The corresponding signal `enemy_changed` will fire.
func set_enemy_character(character: Character) -> void:
	_enemy_character = character
	enemy_changed.emit(character)

#endregion


#region public

## This method is asynchronous.
func do_purge() -> void:
	pass


## This method is asynchronous.
func do_battle(battle_info: ArenaBattleInfo) -> void:
	pass

#endregion


#region static

static func make(info: ArenaInfo, player: PlayerInfo) -> Arena:
	return

#endregion
