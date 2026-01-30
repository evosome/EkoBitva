class_name RoundPath extends RefCounted


#region fields

var _index: int = 0
var _checkpoints: Array[Checkpoint]

#endregion


#region builtins

func _init(round_sequencer: RoundSequencer) -> void:
	_init_rounds(round_sequencer)

#endregion


#region public

func get_size() -> int:
	return _checkpoints.size()


func get_next() -> Round:
	var checkpoint = _checkpoints[_index]
	_index += 1

	var round_instance = checkpoint._round
	return round_instance


func get_checkpoints() -> Array[Checkpoint]:
	return _checkpoints

#endregion


#region private

func _init_rounds(round_sequencer: RoundSequencer) -> void:
	while round_sequencer.has_next():
		var round_type = round_sequencer.get_next()
		var round_instance = Round.new(round_type)
		var round_checkpoint = Checkpoint.new(round_instance)
		_checkpoints.append(round_checkpoint)

#endregion


#region inner classes

class Checkpoint:

	signal passed()

	var _round: Round
	
	func _init(round_instance: Round) -> void:
		_round = round_instance
		_round.over.connect(func(): passed.emit())
	
	func get_round_info() -> RoundInfo:
		return _round.get_info()

#endregion
