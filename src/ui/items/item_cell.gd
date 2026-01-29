class_name ItemCellUI extends Control


#region constants

const COMMON_RARITY_COLOR = Color.GRAY
const RARE_RARITY_COLOR = Color.GREEN
const EPIC_RARITY_COLOR = Color.PURPLE
const LEGENDARY_RARITY_COLOR = Color.GOLD

const RARITY_COLOR_MAP = {
	Accessory.Rarity.COMMON: COMMON_RARITY_COLOR,
	Accessory.Rarity.RARE: RARE_RARITY_COLOR,
	Accessory.Rarity.EPIC: EPIC_RARITY_COLOR,
	Accessory.Rarity.LEGENDARY: LEGENDARY_RARITY_COLOR,
}

const COMMON_QUALITY_COLOR = Color.WHITE
const GOOD_QUALITY_COLOR = Color.GREEN
const BEST_QUALITY_COLOR = Color.GOLD

const QUALITY_COLOR_MAP = {
	Accessory.Quality.COMMON: COMMON_QUALITY_COLOR,
	Accessory.Quality.GOOD: GOOD_QUALITY_COLOR,
	Accessory.Quality.BEST: BEST_QUALITY_COLOR
}

#endregion


#region fields

var _item: Accessory

@export var _item_icon: TextureRect
@export var _cell_panel: Panel
@export var _quality_star: TextureRect

#endregion


#region builtins

func _ready() -> void:
	reset()
	if _item:
		wrap_item(_item)

#endregion


#region public

## Dynamicly wrap item and apply visibility changes for new wrapped item
func wrap_item(value: Accessory) -> void:
	var item_type = value.get_type()

	var rarity = value.get_rarity()
	_set_cell_color_by(rarity)

	var item_texture = item_type.icon
	_set_icon_texture(item_texture)

	var quality = value.get_quality()
	_set_quality_star_color_by(quality)
	_set_quality_star_visible(true)

	_item = value


## Reset item cell to empty, containing nothing
func reset() -> void:
	_set_icon_texture(null)
	_set_quality_star_visible(false)

#endregion


#region private

func _set_icon_texture(value: Texture2D) -> void:
	_item_icon.texture = value


func _set_cell_color(value: Color) -> void:
	_cell_panel.modulate = value


func _set_cell_color_by(rarity: Accessory.Rarity) -> void:
	var rarity_color = RARITY_COLOR_MAP.get(rarity)
	_set_cell_color(rarity_color)


func _set_quality_star_color(value: Color) -> void:
	_quality_star.modulate = value


func _set_quality_star_color_by(value: Accessory.Quality) -> void:
	var quality_color = QUALITY_COLOR_MAP[value]
	_quality_star.modulate = quality_color


func _set_quality_star_visible(value: bool) -> void:
	_quality_star.visible = value

#endregion


#region static

static func of(item: Accessory) -> ItemCellUI:
	var item_cell = Registry.instantiate(Id.of_game("scenes.ui.items", "ItemCell")) as ItemCellUI
	item_cell._item = item
	return item_cell


static func empty() -> ItemCellUI:
	return of(null)

#endregion
