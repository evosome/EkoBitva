class_name QuestionPool


#region fields

static var pool: Dictionary = {}

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
	_question_types.append(question_type)
	return Question.of(question_type, _question_bank)

#endregion


#region static

static func of(question_bank: QuestionBank) -> QuestionPool:
	return pool.get(question_bank, QuestionPool.new(question_bank))

#endregion
