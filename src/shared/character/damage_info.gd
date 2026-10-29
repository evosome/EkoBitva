class_name DamageInfo


#region fields

var _amount: int

#endregion


#region builtins

func _init(amount: int) -> void:
    _amount = amount

#endregion


#region getters/setters

func get_amount() -> int:
    return _amount

#endregion


#region static

static func with(amount: int) -> DamageInfo:
    return DamageInfo.new(amount)

#endregion
