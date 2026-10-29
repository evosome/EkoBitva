class_name ArrayRoundSequence extends RoundSequence


#region fields

@export var _ordered_round_types: Array[RoundType]

#endregion


#region overrides

func get_round_types() -> Array[RoundType]:
  return _ordered_round_types

#endregion
