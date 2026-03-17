class_name Accessory


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


#region constants

const ALL_RARITIES = [Rarity.COMMON, Rarity.RARE, Rarity.EPIC, Rarity.LEGENDARY]
const ALL_QUALITIES = [Quality.COMMON, Quality.GOOD, Quality.BEST]

#endregion


#region fields

var _type: AccessoryType
var _tier: int
var _rarity: Rarity
var _quality: Quality

#endregion


#region builtins

func _init(type: AccessoryType) -> void:
	_type = type

#endregion


#region getters/setters

func get_quality() -> Quality:
	return _quality

func get_rarity() -> Rarity:
	return _rarity

func get_tier() -> int:
	return _tier

func get_type() -> AccessoryType:
	return _type

#endregion


#region static

static func of(type: AccessoryType) -> Accessory:
	return Accessory.new(type)


static func build_of(type: AccessoryType) -> Builder:
	return Builder.new(of(type))


static func random_of(type: AccessoryType) -> RandomBuilder:
	return RandomBuilder.new(of(type))

#endregion


#region inner classes

class Builder:

	var _item: Accessory

	func _init(item: Accessory) -> void:
		_item = item
	
	func of_tier(value: int) -> Builder:
		_item._tier = value
		return self
	
	func of_rarity(value: Rarity) -> Builder:
		_item._rarity = value
		return self
	
	func with_quality(value: Quality) -> Builder:
		_item._quality = value
		return self
	
	func build() -> Accessory:
		return _item


class RandomBuilder:

	var _item: Accessory

	func _init(item: Accessory) -> void:
		_item = item
	
	func range_tier(start: int, end: int) -> RandomBuilder:
		_item._tier = randi_range(start, end)
		return self
	
	func include_rarity(values: Array) -> RandomBuilder:
		_item._rarity = values.pick_random()
		return self
	
	func include_quality(values: Array) -> RandomBuilder:
		_item._quality = values.pick_random()
		return self
	
	func build() -> Accessory:
		return _item

#endregion
