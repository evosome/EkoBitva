## Game screen, containing info about player (stats, items and e.t.c)
## and roadmap tree map.
class_name LevelSelectionScreen extends Screen


#region fields

var _player_data: PlayerInfo

@export var _roadmap_container: Node
@export var _inventory_container: Node

#endregion


#region overrides

func on_enter(ctx: Context) -> void:
	var roadmap = ctx.roadmap
	if !roadmap:
		push_error("Entered `LevelSelectionScreen`, but `roadmap` reference was not set in context")
		return
	_setup_roadmap(roadmap)

	_player_data = ctx.player_data
	if !_player_data:
		push_error("Entered `LevelSelectionScreen`, but `player_data` was not set in context")
		return
	_setup_inventory_by(_player_data)


func on_exit() -> void:
	return

#endregion


#region private

func _setup_roadmap(roadmap: Roadmap) -> void:
	_roadmap_container.add_child(roadmap)
	roadmap.icon_selected.connect(_on_icon_selected)


func _setup_inventory_by(player_data: PlayerInfo) -> void:
	var inventory_ui = null
	#_inventory_container.add_child(inventory_ui)


func _switch_battle_screen_with(level_attempt: LevelAttempt) -> void:
	var battle_screen = Registry.instantiate(Id.of_game("scenes.screens", "BattleScreen"))

	var context = BattleScreen.Context.new()
	context.level_attempt = level_attempt
	switch_to(battle_screen, null)

#endregion


#region event handlers

func _on_icon_selected(level_icon: LevelIcon) -> void:
	var level_node = level_icon.get_level_node()
	var level = level_node.get_level()
	var level_attempt = level.make_attempt(_player_data)
	_switch_battle_screen_with(level_attempt)

#endregion


#region inner classes

class Context:
	var roadmap: Roadmap
	var player_data: PlayerInfo

#endregion
