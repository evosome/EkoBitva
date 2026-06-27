class_name Question extends RefCounted


#region fields

var _type: QuestionType
var _question_bank: QuestionBank
var _timeout_seconds: int = -1

#endregion


#region builtins

func _init(type: QuestionType, question_bank: QuestionBank) -> void:
	_type = type
	_question_bank = question_bank
	_timeout_seconds = _type.seconds_to_answer

#endregion


#region getters/setters

func get_type() -> QuestionType:
	return _type


func get_question_bank() -> QuestionBank:
	return _question_bank


func has_timeout() -> bool:
	return _timeout_seconds > 0


func get_timeout() -> int:
	return _timeout_seconds

#endregion


#region static

static func of(type: QuestionType, question_bank: QuestionBank) -> Question:
	return Question.new(type, question_bank)

#endregion
