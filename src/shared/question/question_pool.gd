class_name QuestionPool


#region fields

var _question_bank: QuestionBank
var _question_types: Array[QuestionType] = []

#endregion


#region builtins

func _init(question_bank: QuestionBank) -> void:
	_question_bank = question_bank

	var question_types = question_bank.question_types
	_question_types = question_types.duplicate()

#endregion


#region public

func queue() -> Question:
	if _question_types.is_empty():
		return null
	
	var question_type = _question_types.pop_front()
	_question_types.push_back(question_type)
	return Question.of(question_type, _question_bank)

#endregion
