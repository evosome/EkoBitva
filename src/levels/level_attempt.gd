class_name LevelAttempt extends RefCounted


#region signal

signal over(result: Result)

#endregion


#region fields

var _arena: Arena
var _is_over: bool
var _current_round: Round
var _treasure_bag: TreasureBag
var _result: Result
var _current_player: PlayerInfo
var _round_sequencer: RoundSequencer

#endregion


#region builtins

func _init(player: PlayerInfo, arena: Arena, round_sequencer: RoundSequencer) -> void:
	_arena = arena
	_current_player = player
	_round_sequencer = round_sequencer
	arena.character_died.connect(_on_character_died)

#endregion


#region getters/setters

func is_over() -> bool:
	return _is_over


func get_arena() -> Arena:
	return _arena


func get_current_round() -> Round:
	return _current_round


func get_treasure_bag() -> TreasureBag:
	return _treasure_bag


func get_result() -> Result:
	return _result

#endregion


#region public

## This method produces new round if the previous one
## has ended.
## Check if a level attemp was not ended to get a new round. Otherwise
## this method will throw error.
func next() -> Round:
	
	if !_current_round.is_over():
		push_error("Unable to produce new round, because the previous one has not over yet")
		return
	
	if _is_over:
		push_error("Unable to produce a new round, because level attemp is over")
		return

	var round_info = _round_sequencer.get_next()
	var round_instance = Round.new(round_info)
	_current_round = round_instance
	return round_instance

#endregion


#region private

func _make_over(is_win: bool) -> void:
	var result = Result.new(is_win, null)
	_result = result
	_is_over = true
	over.emit(result)

#endregion


#region event handlers

func _on_character_died(character: Character) -> void:
	var is_win = false

	# if the player character is died, we lose
	if character:
		is_win = false
	# if non-player character died and there's no more rounds, we win
	elif !_round_sequencer.has_next():
		is_win = true
	# otherwise skip
	else:
		return
	
	_make_over(is_win)

#endregion


#region static

static func on(arena: Arena, with_player: PlayerInfo, with_rounds: RoundSequencer) -> LevelAttempt:
	return LevelAttempt.new(with_player, arena, with_rounds)

#endregion


#region inner classes

class Result extends RefCounted:

	var _is_win: bool
	var _final_treasure_bag: TreasureBag

	func _init(win: bool, final_treasure_bag: TreasureBag):
		_is_win = win
		_final_treasure_bag = final_treasure_bag

	func is_win() -> bool:
		return _is_win

	func get_final_treasure_bag() -> TreasureBag:
		return _final_treasure_bag

#endregion
