class_name LevelResult


#region fields

var _is_win: bool
var _final_treasure_bag: TreasureBag
var _unlocked_fishes: Array[FishType]

#endregion


#region getters/setters

func is_win() -> bool:
    return _is_win


func get_final_treasure_bag() -> TreasureBag:
    return _final_treasure_bag


func get_unlocked_fishes() -> Array[FishType]:
    return _unlocked_fishes

#endregion
