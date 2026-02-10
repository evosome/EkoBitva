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

#endregion
