class_name RoundSequencer extends Resource


#region fields

@export var _round_types: Array[RoundInfo]
@export var _need_shuffle: bool = true

#endregion


#region builtins

func _init() -> void:
    if _need_shuffle:
        _round_types.shuffle()

#endregion


#region public

func get_all() -> Array[RoundInfo]:
    return _round_types

#endregion
