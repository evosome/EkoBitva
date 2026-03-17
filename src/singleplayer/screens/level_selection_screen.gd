## Game screen, containing info about player (stats, items and e.t.c)
## and roadmap tree map.
class_name LevelSelectionScreen extends Screen


#region constants

const BATTLE_SCREEN = preload("uid://37vgamfipd14")

#endregion


#region fields

var _roadmap: Roadmap
var _player_data: PlayerInfo

@export var _roadmap_container: Node
@export var _player_info_container: Node

#endregion


#region overrides

func on_enter(ctx: Context) -> void:
	_roadmap = ctx.roadmap
	if !_roadmap:
		push_error("Entered `LevelSelectionScreen`, but `roadmap` reference was not set in context")
		return
	_setup_roadmap(_roadmap)

	_player_data = ctx.player_data
	if !_player_data:
		push_error("Entered `LevelSelectionScreen`, but `player_data` was not set in context")
		return
	_setup_player_info(_player_data)


func on_exit() -> void:
	_roadmap_container.remove_child(_roadmap)

#endregion


#region private

func _setup_roadmap(roadmap: Roadmap) -> void:
	var roadmap_ui = RoadmapUI.of(roadmap)
	_roadmap_container.add_child(roadmap_ui)
	roadmap_ui.icon_selected.connect(_on_icon_selected, CONNECT_ONE_SHOT)


func _setup_player_info(player_data: PlayerInfo) -> void:
	var player_info_ui = PlayerInfoUI.of(player_data)
	_player_info_container.add_child(player_info_ui)


func _switch_battle_screen_with(level_attempt: LevelAttempt) -> void:
	var battle_screen = BATTLE_SCREEN.instantiate()

	var context = BattleScreen.Context.new()
	context.level_attempt = level_attempt
	context.roadmap = _roadmap
	context.player_info = _player_data
	switch_to(battle_screen, context)

#endregion


#region event handlers

func _on_icon_selected(level_icon: LevelIcon) -> void:
	var level_node = level_icon.get_level_node()
	
	if !level_node.is_unlocked():
		return

	var level = level_node.get_level()
	var level_attempt = level.make_attempt(_player_data)
	_switch_battle_screen_with(level_attempt)

#endregion


#region inner classes

class Context:
	var roadmap: Roadmap
	var player_data: PlayerInfo

#endregion
