class_name Question extends RefCounted


#region signals

signal answered(result: Result)

#endregion


#region fields

var _type: QuestionType
var _countdown_timer: CountdownTimer
var _question_bank: QuestionBank

#endregion


#region builtins

func _init(type: QuestionType, question_bank: QuestionBank) -> void:
	_type = type
	_question_bank = question_bank

	var seconds_to_answer = type.seconds_to_answer
	_countdown_timer = CountdownTimer.new(seconds_to_answer) if seconds_to_answer > 0 else null

#endregion


#region getters/setters

func get_type() -> QuestionType:
	return _type


func get_countdown() -> CountdownTimer:
	return _countdown_timer


func has_countdown() -> bool:
	return _countdown_timer != null


func get_question_bank() -> QuestionBank:
	return _question_bank

#endregion


#region public

func answer(variant_idx: int) -> Result:
	_countdown_timer.stop()

	var correct_idx = _type.correct_answer_index
	var result = Result.new(variant_idx, correct_idx)
	answered.emit(result)
	
	return result

#endregion


#region inner classes

class Result:

	var _user_answer_idx: int
	var _correct_answer_idx: int

	func _init(user_answer_idx: int, correct_answer_idx: int) -> void:
		_user_answer_idx = user_answer_idx
		_correct_answer_idx = correct_answer_idx
	
	func is_correct() -> bool:
		return _user_answer_idx == _correct_answer_idx
	
	func get_correct_answer_idx() -> int:
		return _correct_answer_idx
	
	func get_user_answer_idx() -> int:
		return _user_answer_idx

#endregion


#region static

static func of(type: QuestionType, question_bank: QuestionBank) -> Question:
	return Question.new(type, question_bank)

#endregion
