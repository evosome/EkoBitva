extends Control


#region constants

const TEST_ITEM_TYPE = preload("res://resources/items/types/icebox.tres")

#endregion


#region fields

var _treasure_bag: TreasureBag

@export var _timer: Timer

#endregion


#region builtins

func _ready() -> void:
	_treasure_bag = TreasureBag.new()
	var treasure_bag_ui = TreasureBagUI.of(_treasure_bag)
	add_child(treasure_bag_ui)
	
	_timer.timeout.connect(_on_timeout)

#endregion


#region event handlers

func _on_timeout() -> void:
	var items: Array[Accessory] = []
	for i in range(0, randi_range(1, 2)):
		items.append(Accessory
			.random_of(TEST_ITEM_TYPE)
			.range_tier(1, 15)
			.include_rarity(Accessory.ALL_RARITIES)
			.include_quality(Accessory.ALL_QUALITIES)
			.build())

	var random_treasure = Treasure.new(randi_range(35, 480), items)
	_treasure_bag.add(random_treasure)

	print("Added new treasure {treasure} to treasure bag".format({
		treasure = random_treasure
	}))

#endregion
