class_name Round extends RefCounted


#region signals

signal over(result: RoundResult)
signal question_spawned(question: Question)

signal _internal_over()

#endregion


#region fields

var _info: RoundInfo
var _enemy_character: Character
var _is_over: bool

#endregion


#region builtins

func _init(info: RoundInfo) -> void:
	_info = info
	_is_over = false

#endregion


#region debug only

func __force_over() -> void:
	if !OS.is_debug_build():
		push_error("Unable to call `__force_over` debug method in non-debug enviroment")
		return
	
	_internal_over.emit()

#endregion


#region getters/setters

func is_over() -> bool:
	return _is_over


func get_info() -> RoundInfo:
	return _info

## Reference to enemy character entity. It should be spawned
## on arena 
func get_enemy_character() -> Character:
	return _enemy_character

#endregion


#region public

## Start fighting with enemy character, defined in `RoundInfo` class.
## The only reason to make a round over is to defeat enemy.
func start() -> Result:
	
	_enemy_character.died.connect(_on_enemy_died)

	await _internal_over

	_enemy_character.died.disconnect(_on_enemy_died)

	_is_over = true
	var random_treasure = _randomize_treasure()
	return Result.new(true, random_treasure)

#endregion


#region private

func _randomize_treasure() -> Treasure:
	return null

#endregion


#region event handlers

func _on_enemy_died() -> void:
	_internal_over.emit()

#endregion


#region inner classes

class Result:
	var _is_win: bool
	var _treasure: Treasure

	func _init(win: bool, treasure: Treasure) -> void:
		_is_win = win
		_treasure = treasure
	
	func is_win() -> bool:
		return _is_win
	
	func get_treasure() -> Treasure:
		return _treasure

#endregion
