class_name Question extends Object

signal answered(result: QuestionAnswer)

func get_type() -> QuestionType:
	pass

func answer(variant: String) -> void:
	pass
