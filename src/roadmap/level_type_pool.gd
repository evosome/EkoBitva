class_name LevelTypePool extends Resource


#region fields

var _pool: Array[LevelInfo]

@export var _level_types: Array[LevelInfo]

#endregion


#region public

func get_next() -> LevelInfo:

    if _pool.size() == 0:
        _fill_and_shuffle()

    return _pool.pop_front()

#endregion


#region private

func _fill_and_shuffle() -> void:
    for type in _level_types:
        _pool.append(type)
    _level_types.shuffle()

#endregion
