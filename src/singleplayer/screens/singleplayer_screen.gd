@abstract
class_name SingleplayerScreen extends Screen


#region abstract

@abstract func on_enter(ctx: Context) -> void
@abstract func on_exit() -> void

#endregion


#region inner classes

class Context:

    var game: SingleplayerGame
    var data: Dictionary

    func _init(game: SingleplayerGame, data: Dictionary) -> void:
        self.game = game
        self.data = data

#endregion
