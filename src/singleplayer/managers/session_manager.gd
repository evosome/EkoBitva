## Owns the current `PlayerSession`: creates it on a new game and
## applies level results (loot, fishtiary, roadmap progress) on level end.
class_name SessionManager extends RefCounted


#region signals

signal session_started(session: PlayerSession)
signal level_result_applied(level: Level, result: LevelResult)

#endregion


#region fields

var _config: GameConfig
var _roadmap_manager: RoadmapManager
var _loot_manager: LootManager
var _session: PlayerSession

#endregion


#region builtins

func _init(
		config: GameConfig,
		roadmap_manager: RoadmapManager,
		loot_manager: LootManager
) -> void:
	_config = config
	_roadmap_manager = roadmap_manager
	_loot_manager = loot_manager

#endregion


#region public

## Builds a brand new game session: roadmap + player data.
func start_new_game() -> PlayerSession:

	var roadmap = _roadmap_manager.generate(_config.generation_info)
	var fish_types = _config.collect_fish_types()

	_session = PlayerSession.new_game(_config.character_type, fish_types, roadmap)
	session_started.emit(_session)

	return _session


func session() -> PlayerSession:

	if !_session:
		push_error("There is no active player session yet")

	return _session


func has_session() -> bool:
	return _session != null


## Writes the finished level attempt outcome into the player session.
func apply_level_result(level: Level, result: LevelResult) -> void:

	if !_session:
		push_error("Unable to apply level result: there is no active session")
		return

	var inventory = _session.get_inventory()
	_loot_manager.consume_treasure_bag(inventory, result.get_final_treasure_bag())

	var fishtiary = _session.get_fishtiary()
	for fish_type in result.get_unlocked_fishes():
		fishtiary.unlock_entry(fish_type)

	if level:
		_session.add_level_result(level, result)
		var node = _roadmap_manager.find_node_by_level(level)
		if node:
			_roadmap_manager.mark_passed(node)

	level_result_applied.emit(level, result)

#endregion
