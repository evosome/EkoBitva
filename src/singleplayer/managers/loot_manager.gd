## Everything about turning a level attempt outcome into player progress:
## loot -> inventory, fish -> fishtiary, level -> roadmap node state.
class_name LootManager extends RefCounted


#region constants

## Amount of accessory rolls inside one treasure
const MIN_LOOT_AMOUNT = Round.MIN_LOOT_AMOUNT
const MAX_LOOT_AMOUNT = Round.MAX_LOOT_AMOUNT

## How far above the round tier a rolled item quality may reach
const MAX_TIER_DRIFT = 2

#endregion


#region public

## Moves every accessory of the bag into the inventory.
func consume_treasure_bag(inventory: Inventory, treasure_bag: TreasureBag) -> void:

	if !treasure_bag:
		return

	for item in treasure_bag.get_items():
		inventory.push(item)


## Rolls gold and accessories for the finished round.
func roll_treasure(round_type: RoundType, tier: int) -> Treasure:

	var gold = round_type.base_gold
	var items: Array[Accessory] = []

	var possible_loot = round_type.possible_loot
	if possible_loot.is_empty():
		return Treasure.new(gold, items)

	for i in range(randi_range(MIN_LOOT_AMOUNT, MAX_LOOT_AMOUNT)):
		var loot_type = possible_loot.pick_random()
		items.append(
			Accessory
				.random_of(loot_type)
				.range_tier(tier, tier + MAX_TIER_DRIFT)
				.include_rarity(Accessory.ALL_RARITIES)
				.include_quality(Accessory.ALL_QUALITIES)
				.build()
		)

	return Treasure.new(gold, items)

#endregion
