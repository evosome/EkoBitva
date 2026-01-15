class_name Round extends RefCounted


#region signals

signal over(result: RoundResult)
signal question_spawned(question: Question)

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


#region getters/setters

func is_over() -> bool:
	return _is_over


## Reference to enemy character entity. It should be spawned
## on arena 
func get_enemy_character() -> Character:
	return _enemy_character

#endregion


#region public

## Start fighting with enemy character, defined in `RoundInfo` class.
## The only reason to make a round over is to defeat enemy.
func start() -> Result:
	await _enemy_character.died

	_is_over = true
	var random_treasure = _randomize_treasure()
	return Result.new(true, random_treasure)

#endregion


#region private

func _randomize_treasure() -> Treasure:
	return null

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
