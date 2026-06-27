class_name AnswerResult


#region enums

enum EndReasons {
	NO_ANSWER,
	ANSWERED
}

#endregion


#region fields

var _reason: EndReasons
var _user_answer_idx: int
var _correct_answer_idx: int

#endregion


#region builtins

func _init(end_reason: EndReasons, user_answer_idx: int, correct_answer_idx: int) -> void:
    _reason = end_reason
    _user_answer_idx = user_answer_idx
    _correct_answer_idx = correct_answer_idx

#endregion


#region getters/setters

func is_correct() -> bool:
    return _user_answer_idx == _correct_answer_idx

func get_correct_answer_idx() -> int:
    return _correct_answer_idx

func get_user_answer_idx() -> int:
    return _user_answer_idx

func get_end_reason() -> EndReasons:
    return _reason

#endregion
