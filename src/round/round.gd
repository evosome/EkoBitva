class_name Round extends RefCounted


#region signals

signal over(result: Result)

#endregion


#region fields

var _info: RoundInfo
var _enemy_character: Character
var _is_over: bool
var _associated_question_pool: QuestionPool
var _current_question: Question
var _result: Result

#endregion


#region builtins

func _init(info: RoundInfo) -> void:
	_info = info
	_is_over = false

	var question_bank = info.associated_question_bank
	_associated_question_pool = QuestionPool.of(question_bank)

	var enemy_type = info.possible_enemy_types.pick_random()
	_enemy_character = Character.of(enemy_type)
	_enemy_character.died.connect(_on_enemy_died)

#endregion


#region debug only

func __force_over() -> void:
	if !OS.is_debug_build():
		push_error("Unable to call `__force_over` debug method in non-debug enviroment")
		return
	
	print("Forcely end the round")
	_do_over()

#endregion


#region getters/setters

func is_over() -> bool:
	return _is_over


func get_result() -> Result:
	return _result


func get_info() -> RoundInfo:
	return _info

## Reference to enemy character entity. It should be spawned
## on arena 
func get_enemy_character() -> Character:
	return _enemy_character


func get_next_question() -> Question:

	if _is_over:
		push_error("Unable to request new question from this round, because it has been ended")
		return null

	if _current_question && !_current_question.is_answered():
		push_error("Unable to request new question, because previous one has been answered")
		return null

	var new_question = _associated_question_pool.queue()
	_current_question = new_question
	return new_question


func can_get_next_question() -> bool:
	return _current_question && _current_question.is_answered() && !_is_over

#endregion


#region private

func _do_over() -> void:
	_is_over = true
	var random_treasure = _randomize_treasure()
	_result = Result.new(true, random_treasure)


func _randomize_treasure() -> Treasure:
	return null

#endregion


#region event handlers

func _on_enemy_died() -> void:
	_do_over()

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
