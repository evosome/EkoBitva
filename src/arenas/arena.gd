class_name Arena extends Node2D


#region signals

## Fires, when any first (both player and enemy) character died
signal character_died(character: Character)

signal enemy_changed(character: Character)

#endregion


#region fields

var _info: ArenaInfo
var _is_purged: bool
var _enemy_character: Character
var _player_character: Character

@export var _player_spawnpoint: Node2D
@export var _enemy_spawnpoint: Node2D

@export var _characters_container: Node

#endregion


#region getters/setters

func is_purged() -> bool:
	return _is_purged


func get_info() -> ArenaInfo:
	return _info


func get_player_character() -> Character:
	return _player_character


func _set_player_character(player_character: Character) -> void:
	_player_character = player_character
	_spawn_character_at(player_character, _player_spawnpoint.position)


## Replace previous character by a new one.
## The corresponding signal `enemy_changed` will fire.
func set_enemy_character(enemy_character: Character) -> void:
	_enemy_character = enemy_character
	_spawn_character_at(enemy_character, _enemy_spawnpoint.position)
	enemy_changed.emit(enemy_character)

#endregion


#region public

## This method is asynchronous.
func do_purge() -> void:
	pass


## This method is asynchronous.
func do_battle(battle_info: ArenaBattleInfo) -> void:
	pass

#endregion


#region private

func _spawn_character_at(character: Character, spawn_position: Vector2) -> void:
	character.position = spawn_position
	character.died.connect(func(): character_died.emit(character))
	_characters_container.add_child(character)

#endregion


#region static

static func make(info: ArenaInfo, player_character: Character) -> Arena:
	var packed_arena = info.packed_scene
	var arena = packed_arena.instantiate() as Arena
	arena._info = info
	arena._player_character = player_character
	return arena

#endregion
