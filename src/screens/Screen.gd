## Screen is special scene with UI components or
## 2D scene inside, that can be switched using `ScreenManager`.
## Only for client-side use.
@abstract
class_name Screen extends Control


#region signals

signal exited()
signal entered()

#endregion


#region fields

var _parent_node: Node

#endregion


#region public

## This method is asynchronous.
## Called, when the screen enters scene tree.
## Each screen can be switched to another with some special
## context object.
## Context is object
func enter(node: Node, ctx = null) -> void:

	if _parent_node:
		push_error("Screen has already been assigned to node: ", _parent_node)
		return
	
	node.add_child(self)
	_parent_node = node
	await on_enter(ctx)
	entered.emit()


## This method is asynchronous.
## Called, when the screen exits scene tree.
func exit() -> void:

	if _parent_node:
		push_error("Screen hasn't been assigned to any node. Unable to exit")
		return

	_parent_node.remove_child(self)
	_parent_node = null
	await on_exit()
	exited.emit()


## This method is asynchronous.
## Replace the current screen with other one on the same parent node.
func switch_to(screen: Screen, ctx = null) -> void:
	await exit()
	await screen.enter(_parent_node, ctx)

#endregion


#region abstract

## This method is protected and should be asynchronous.
@abstract func on_enter(ctx) -> void

## This method is protected and should be asynchronous.
@abstract func on_exit() -> void

#endregion
