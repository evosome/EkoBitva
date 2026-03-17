class_name RoundPath extends RefCounted


#region fields

var _index: int = 0
var _arena: Arena
var _checkpoints: Array[Checkpoint]
var _current_tier: int

#endregion


#region builtins

func _init(round_sequencer: RoundSequencer, arena: Arena, tier: int) -> void:
	_arena = arena
	_current_tier = tier
	_init_rounds(round_sequencer)

#endregion


#region getters/setters

func get_size() -> int:
	return _checkpoints.size()


func get_next() -> Round:
	var checkpoint = _checkpoints[_index]
	_index += 1

	var round_instance = checkpoint._round
	return round_instance


func has_next() -> bool:
	return _index < _checkpoints.size()


func get_checkpoints() -> Array[Checkpoint]:
	return _checkpoints

#endregion


#region private

func _init_rounds(round_sequencer: RoundSequencer) -> void:
	var round_types = round_sequencer.get_all()
	for round_type in round_types:
		var round_instance = Round.new(round_type, _arena, _current_tier)
		var round_checkpoint = Checkpoint.new(round_instance)
		_checkpoints.append(round_checkpoint)

#endregion


#region inner classes

class Checkpoint:

	signal passed()

	var _round: Round
	
	func _init(round_instance: Round) -> void:
		_round = round_instance
		_round.over.connect(func(_result): passed.emit())
	
	func get_round_info() -> RoundInfo:
		return _round.get_info()

#endregion
