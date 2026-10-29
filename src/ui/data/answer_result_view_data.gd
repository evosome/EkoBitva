## View-layer data holder describing how to highlight answers after the player answered.
class_name AnswerResultViewData extends RefCounted


#region fields

var correct_index: int = -1
var user_index: int = -1
var is_correct: bool = false

#endregion


#region static

static func of(correct_index: int, user_index: int, is_correct: bool) -> AnswerResultViewData:
	var data = AnswerResultViewData.new()
	data.correct_index = correct_index
	data.user_index = user_index
	data.is_correct = is_correct
	return data

#endregion
