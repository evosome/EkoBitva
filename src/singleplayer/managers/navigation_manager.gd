## Owns the screens host node and switches between registered screens.
## Presenters never preload each other's scenes anymore: they ask this manager.
class_name NavigationManager extends RefCounted


#region signals

signal switched(screen: Screen)

#endregion


#region fields

var _host: Node
var _current: Screen

#endregion


#region builtins

func _init(host: Node) -> void:
	_host = host

#endregion


#region public

## This method is asynchronous.
## Instantiates the screen registered under `qualified_name`
## and replaces the current screen with it.
func switch_to(qualified_name: String, ctx = null) -> void:

	var screen = _instantiate_screen(qualified_name)
	if !screen:
		return

	if _current:
		await _current.exit()

	_current = screen
	await screen.enter(_host, ctx)
	switched.emit(screen)


## This method is asynchronous.
## Removes the current screen from the host node.
func clear() -> void:
	if !_current:
		return

	var screen = _current
	_current = null
	await screen.exit()


func current() -> Screen:
	return _current

#endregion


#region private

func _instantiate_screen(qualified_name: String) -> Screen:
	var id = Id.of_game(GameConfig.SCREENS_REGISTRY_PATH, qualified_name)
	var screen = Registry.instantiate(id) as Screen

	if !screen:
		push_error("Unable to instantiate screen: ", qualified_name)

	return screen

#endregion
