## Passive view of a single inventory/treasure cell.
class_name ItemCellUI extends Control


#region constants

const ITEM_CELL_UI_SCENE = preload("uid://cypsyqthk6gbh")

const COMMON_RARITY_COLOR = Color.GRAY
const RARE_RARITY_COLOR = Color.GREEN
const EPIC_RARITY_COLOR = Color.PURPLE
const LEGENDARY_RARITY_COLOR = Color.GOLD

const RARITY_COLOR_MAP = {
	ItemViewData.Rarity.COMMON: COMMON_RARITY_COLOR,
	ItemViewData.Rarity.RARE: RARE_RARITY_COLOR,
	ItemViewData.Rarity.EPIC: EPIC_RARITY_COLOR,
	ItemViewData.Rarity.LEGENDARY: LEGENDARY_RARITY_COLOR,
}

const COMMON_QUALITY_COLOR = Color.WHITE
const GOOD_QUALITY_COLOR = Color.GREEN
const BEST_QUALITY_COLOR = Color.GOLD

const QUALITY_COLOR_MAP = {
	ItemViewData.Quality.COMMON: COMMON_QUALITY_COLOR,
	ItemViewData.Quality.GOOD: GOOD_QUALITY_COLOR,
	ItemViewData.Quality.BEST: BEST_QUALITY_COLOR
}

#endregion


#region fields

var _data: ItemViewData

@export var _item_icon: TextureRect
@export var _cell_panel: Panel
@export var _quality_star: TextureRect

#endregion


#region builtins

func _ready() -> void:
	if _data:
		_render()
	else:
		reset()

#endregion


#region public (presenter-facing)

## Shows the item described by `data`.
func set_item(data: ItemViewData) -> void:
	_data = data
	_render()


## Resets item cell to empty, containing nothing.
func reset() -> void:
	_data = null
	_set_icon_texture(null)
	_set_quality_star_visible(false)

#endregion


#region private

func _render() -> void:

	if !_data:
		reset()
		return

	_set_cell_color(RARITY_COLOR_MAP.get(_data.rarity, COMMON_RARITY_COLOR))
	_set_icon_texture(_data.icon)
	_set_quality_star_color(QUALITY_COLOR_MAP.get(_data.quality, COMMON_QUALITY_COLOR))
	_set_quality_star_visible(true)


func _set_icon_texture(value: Texture2D) -> void:
	_item_icon.texture = value


func _set_cell_color(value: Color) -> void:
	_cell_panel.modulate = value


func _set_quality_star_color(value: Color) -> void:
	_quality_star.modulate = value


func _set_quality_star_visible(value: bool) -> void:
	_quality_star.visible = value

#endregion


#region static

static func of(data: ItemViewData) -> ItemCellUI:
	var item_cell = ITEM_CELL_UI_SCENE.instantiate() as ItemCellUI
	if data:
		item_cell._data = data
	return item_cell


static func empty() -> ItemCellUI:
	return of(null)

#endregion
