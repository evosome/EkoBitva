class_name RoundSequencer extends Resource


#region fields

var _index: int = 0

@export var _round_types: Array[RoundInfo]
@export var _need_shuffle: bool = true

#endregion


#region builtins

func _init() -> void:
    if _need_shuffle:
        _round_types.shuffle()

#endregion


#region getters/setters

func get_next() -> RoundInfo:
    var round_type = _round_types[_index]
    _index += 1
    return round_type


func has_next() -> bool:
    return _index < _round_types.size()

#endregion
