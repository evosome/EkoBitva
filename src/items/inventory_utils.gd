class_name InventoryUtils


#region static

static func consume_treasure_bag(inventory: Inventory, treasure_bag: TreasureBag) -> void:
    var treasure_items = treasure_bag.get_items()
    for treasure_item in treasure_items:
        inventory.push(treasure_item)

#endregion
