class_name Question extends RefCounted


#region enums

enum EndReasons {
	NO_ANSWER,
	ANSWERED
}

#endregion


#region signals

signal over(result: Result)

#endregion


#region fields

var _type: QuestionType
var _countdown_timer: CountdownTimer
var _question_bank: QuestionBank
var _current_result: Result
var _is_running: bool = false
var _timeout_seconds: int = -1

#endregion


#region builtins

func _init(type: QuestionType, question_bank: QuestionBank) -> void:
	_type = type
	_question_bank = question_bank
	_timeout_seconds = _type.seconds_to_answer
	
	if _has_timeout():
		_countdown_timer = CountdownTimer.new(_timeout_seconds)
		_countdown_timer.timeout.connect(_on_countdown_timeout)

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


func is_answered() -> bool:
	return _current_result != null


func get_result() -> Result:
	return _current_result


func _has_timeout() -> bool:
	return _timeout_seconds > 0

#endregion


#region public

## Make it possible to answer on question with countdown (if present in type info).
func start() -> void:
	_is_running = true
	
	if _has_timeout():
		_countdown_timer.start()


func answer(variant_idx: int) -> Result:

	if !_is_running:
		push_error(
			"Unable to answer on question, because it has not been " + 
			"started yet. Call `start` method to make it possible to answer this question")
		return

	if _has_timeout():
		_countdown_timer.stop()
		_countdown_timer.timeout.disconnect(_on_countdown_timeout)

	_do_over_with(EndReasons.ANSWERED, variant_idx)
	return _current_result

#endregion


#region private

func _do_over_with(reason: EndReasons, user_answer_idx: int) -> void:
	var correct_idx = _type.correct_answer_index
	var result = Result.new(reason, user_answer_idx, correct_idx)
	_current_result = result
	over.emit(result)

#endregion


#region event handlers

func _on_countdown_timeout() -> void:
	_countdown_timer.timeout.disconnect(_on_countdown_timeout)
	_do_over_with(EndReasons.NO_ANSWER, -1)

#endregion


#region inner classes

class Result:

	var _reason: EndReasons
	var _user_answer_idx: int
	var _correct_answer_idx: int

	func _init(end_reason: EndReasons, user_answer_idx: int, correct_answer_idx: int) -> void:
		_reason = end_reason
		_user_answer_idx = user_answer_idx
		_correct_answer_idx = correct_answer_idx
	
	func is_correct() -> bool:
		return _user_answer_idx == _correct_answer_idx
	
	func get_correct_answer_idx() -> int:
		return _correct_answer_idx
	
	func get_user_answer_idx() -> int:
		return _user_answer_idx
	
	func get_end_reason() -> EndReasons:
		return _reason

#endregion


#region static

static func of(type: QuestionType, question_bank: QuestionBank) -> Question:
	return Question.new(type, question_bank)

#endregion
