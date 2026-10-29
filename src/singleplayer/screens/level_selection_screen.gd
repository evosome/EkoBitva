## Presenter of the level selection screen. It mirrors the roadmap and the
## player session into passive views and forwards level choice to managers.
class_name LevelSelectionScreen extends Screen


#region fields

@export var _roadmap_container: Node
@export var _player_info_container: Node

var _game: GameContext
var _session: PlayerSession

var _roadmap_ui: RoadmapUI
var _player_info_ui: PlayerInfoUI
var _inventory_ui: InventoryUI
var _fishtiary_ui: FishtiaryUI

var _level_tree: LevelTree
var _nodes_by_id: Dictionary[StringName, LevelTree.LevelNode] = {}
var _node_state_handlers: Dictionary[StringName, Callable] = {}

#endregion


#region screen

func on_enter(ctx) -> void:

	_game = ctx.game
	_session = _game.session.session()

	if !_session:
		push_error("There is no active session to select level from")
		return

	_setup_player_info_view()
	_setup_roadmap_view()


func on_exit() -> void:
	_disconnect_model_signals()
	_free_views()

#endregion


#region private (roadmap)

func _setup_roadmap_view() -> void:

	_roadmap_ui = RoadmapUI.make()
	_roadmap_container.add_child(_roadmap_ui)
	_roadmap_ui.icon_selected.connect(_on_icon_selected)

	_level_tree = _session.get_roadmap().get_level_tree()
	_level_tree.node_added.connect(_on_level_node_added)
	_draw_node(_level_tree.get_root(), null)

	var first_unlocked = _game.roadmap.find_first_unlocked_node()
	if first_unlocked:
		_roadmap_ui.zoom_to(first_unlocked.get_position())


func _draw_node(node: LevelTree.LevelNode, parent: LevelTree.LevelNode) -> void:

	if !node:
		return

	_add_node(node)

	if parent:
		_roadmap_ui.add_level_line(ViewDataFactory.level_line(node, parent))

	for child in node.get_children():
		_draw_node(child, node)


func _add_node(node: LevelTree.LevelNode) -> void:
	var data = ViewDataFactory.level_node(node)
	var handler = _on_node_state_changed.bind(node)
	_nodes_by_id[data.id] = node
	_node_state_handlers[data.id] = handler
	node.state_changed.connect(handler)
	_roadmap_ui.add_level_node(data)

#endregion


#region private (player info)

func _setup_player_info_view() -> void:

	_player_info_ui = PlayerInfoUI.make()
	_player_info_container.add_child(_player_info_ui)

	var character_type = _session.get_character_type()
	_player_info_ui.set_character_name(character_type.name)
	_player_info_ui.set_character_icon(character_type.icon)

	_setup_inventory_view()
	_setup_fishtiary_view()


func _setup_inventory_view() -> void:

	_inventory_ui = InventoryUI.make()
	_player_info_ui.inventory_container().add_child(_inventory_ui)
	_inventory_ui.fill_slots(Inventory.DEFAULT_SIZE)
	_render_inventory()

	_session.get_inventory().accessory_added.connect(_on_accessory_added)
	_session.get_inventory().accessory_removed.connect(_on_accessory_removed)


func _setup_fishtiary_view() -> void:

	_fishtiary_ui = FishtiaryUI.make()
	_player_info_ui.fishtiary_container().add_child(_fishtiary_ui)

	for entry in _session.get_fishtiary().get_entries():
		_fishtiary_ui.add_entry(ViewDataFactory.fish_entry(entry))

	_session.get_fishtiary().entry_unlocked.connect(_on_entry_unlocked)


func _render_inventory() -> void:
	var items = ViewDataFactory.inventory(_session.get_inventory())
	for index in _inventory_ui.get_slots():
		_inventory_ui.set_item(index, items[index] if index < items.size() else null)

#endregion


#region event handlers

func _on_icon_selected(id: StringName) -> void:

	var node = _nodes_by_id.get(id)
	if !node or !node.is_unlocked():
		return

	var level = node.get_level()
	var battle = _game.start_battle(level)
	_game.navigation.switch_to("BattleScreen", BattleScreen.Context.new(_game, battle))


func _on_level_node_added(node: LevelTree.LevelNode, parent: LevelTree.LevelNode) -> void:
	_add_node(node)
	if parent:
		_roadmap_ui.add_level_line(ViewDataFactory.level_line(node, parent))


func _on_node_state_changed(_state: LevelTree.NodeStates, node: LevelTree.LevelNode) -> void:
	_roadmap_ui.set_level_node_state(ViewDataFactory.node_id(node), ViewDataFactory.node_state(node))


func _on_accessory_added(accessory: Accessory, index: int) -> void:
	_inventory_ui.set_item(index, ViewDataFactory.item_of(accessory))


func _on_accessory_removed(_accessory: Accessory, index: int) -> void:
	_inventory_ui.clear_item(index)


func _on_entry_unlocked(entry: Fishtiary.Entry) -> void:
	var fish_type = entry.get_fish_type()
	_fishtiary_ui.set_entry_unlocked(ViewDataFactory.resource_id(fish_type), fish_type.name)

#endregion


#region private (teardown)

func _disconnect_model_signals() -> void:

	if _level_tree:
		_level_tree.node_added.disconnect(_on_level_node_added)

	for id in _node_state_handlers.keys():
		_nodes_by_id[id].state_changed.disconnect(_node_state_handlers[id])

	_nodes_by_id.clear()
	_node_state_handlers.clear()

	if _session:
		_session.get_inventory().accessory_added.disconnect(_on_accessory_added)
		_session.get_inventory().accessory_removed.disconnect(_on_accessory_removed)
		_session.get_fishtiary().entry_unlocked.disconnect(_on_entry_unlocked)


func _free_views() -> void:

	if _roadmap_ui:
		_roadmap_ui.queue_free()
		_roadmap_ui = null

	if _player_info_ui:
		_player_info_ui.queue_free()
		_player_info_ui = null

	_inventory_ui = null
	_fishtiary_ui = null

#endregion
