class_name LevelResult


#region fields

var _is_win: bool
var _final_treasure_bag: TreasureBag
var _unlocked_fishes: Array[FishType]

#endregion


#region builtins

func _init(
        is_win: bool,
        final_treasure_bag: TreasureBag,
        unlocked_fishes: Array[FishType] = []
) -> void:
    _is_win = is_win
    _final_treasure_bag = final_treasure_bag
    _unlocked_fishes = unlocked_fishes

#endregion


#region getters/setters

func is_win() -> bool:
    return _is_win


func get_final_treasure_bag() -> TreasureBag:
    return _final_treasure_bag


func get_unlocked_fishes() -> Array[FishType]:
    return _unlocked_fishes

#endregion


#region static

static func of(
        is_win: bool,
        final_treasure_bag: TreasureBag,
        unlocked_fishes: Array[FishType] = []
) -> LevelResult:
    return LevelResult.new(is_win, final_treasure_bag, unlocked_fishes)

#endregion
