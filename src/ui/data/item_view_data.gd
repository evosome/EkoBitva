## View-layer data holder describing a single accessory cell.
## Presenters build it from `Accessory` model, views consume it.
class_name ItemViewData extends RefCounted


#region enums

enum Rarity {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}

enum Quality {
	COMMON,
	GOOD,
	BEST
}

#endregion


#region fields

var icon: Texture2D
var rarity: Rarity = Rarity.COMMON
var quality: Quality = Quality.COMMON

#endregion


#region static

static func of(icon: Texture2D, rarity: Rarity = Rarity.COMMON, quality: Quality = Quality.COMMON) -> ItemViewData:
	var data = ItemViewData.new()
	data.icon = icon
	data.rarity = rarity
	data.quality = quality
	return data

#endregion
