class_name BattleScreen extends Screen


#region overrides

func on_enter(ctx: Context) -> void:
	pass


func on_exit() -> void:
	pass

#endregion


#region inner classes

class Context:
	var level_attempt: LevelAttempt


## Base class for all battle states
class BattleState:
	pass


class IntroState:
	pass


class ShowQuestionState:
	pass


class QuestionAnswerState:
	pass


class BattleShowState:
	pass


class OutroState:
	pass

#endregion
