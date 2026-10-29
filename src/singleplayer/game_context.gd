## Composition root of the singleplayer game: builds every manager once and
## hands them to the screen presenters through their `Context`.
class_name GameContext extends RefCounted


#region fields

var host: Node

var config: GameConfig
var navigation: NavigationManager
var roadmap: RoadmapManager
var loot: LootManager
var session: SessionManager

## Manager of the currently running battle, if any
var battle: BattleManager

#endregion


#region static

static func bootstrap(host: Node) -> GameContext:

	var context = GameContext.new()
	context.host = host

	context.config = GameConfig.new()
	context.navigation = NavigationManager.new(host)
	context.roadmap = RoadmapManager.new()
	context.loot = LootManager.new()
	context.session = SessionManager.new(context.config, context.roadmap, context.loot)

	return context

#endregion


#region public

## Builds a battle manager for the given level and keeps it as the current one.
func start_battle(level: Level) -> BattleManager:

	#end_battle()

	battle = BattleManager.new(host, loot, session)
	battle.start(level)

	return battle


## Drops the currently running battle (if any).
func end_battle() -> void:

	if !battle:
		return

	battle.cancel()
	battle = null

#endregion
