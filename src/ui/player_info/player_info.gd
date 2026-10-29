## Passive view of the player info panel. It only knows how to show
## the character and where to place sub-views built by the presenter.
class_name PlayerInfoUI extends Control


#region constants

const PLAYER_INFO_UI_SCENE = preload("uid://bdb3xip1yotfl")

#endregion


#region fields

@export var _inventory_ui_container: Control
@export var _fishtiary_ui_container: Control
@export var character_name_label: Label
@export var character_icon_texture_rect: TextureRect

#endregion


#region setters (presenter-facing)

func set_character_name(value: String) -> void:
	character_name_label.text = value


func set_character_icon(value: Texture2D) -> void:
	character_icon_texture_rect.texture = value


## Container where the presenter should place the inventory view.
func inventory_container() -> Control:
	return _inventory_ui_container


## Container where the presenter should place the fishtiary view.
func fishtiary_container() -> Control:
	return _fishtiary_ui_container

#endregion


#region static

static func make() -> PlayerInfoUI:
	return PLAYER_INFO_UI_SCENE.instantiate() as PlayerInfoUI

#endregion
