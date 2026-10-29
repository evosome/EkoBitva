class_name LevelAttempt extends RefCounted


#region fields

var _level: Level
var _arena: Arena
var _player_character: Character
var _treasure_bag: TreasureBag
var _round_sequence: RoundSequence

#endregion


#region builtins

func _init(
        level: Level,
        arena: Arena,
        treasure_bag: TreasureBag,
        round_sequence: RoundSequence,
        player_character: Character
) -> void:

    _level = level
    _arena = arena
    _treasure_bag = treasure_bag
    _round_sequence = round_sequence
    _player_character = player_character

#endregion


#region getters/setters

func get_level() -> Level:
    return _level


func get_arena() -> Arena:
    return _arena


func get_treasure_bag() -> TreasureBag:
    return _treasure_bag


func get_round_sequence() -> RoundSequence:
    return _round_sequence


func get_player_character() -> Character:
    return _player_character

#endregion
