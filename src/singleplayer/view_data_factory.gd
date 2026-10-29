## Presenter-side glue: turns passive game models into the view data
## objects that passive views in `src/ui` are able to consume.
class_name ViewDataFactory extends RefCounted


#region roadmap

static func node_id(node: LevelTree.LevelNode) -> StringName:
	return &"%d" % node.get_instance_id()


static func level_node(node: LevelTree.LevelNode) -> LevelNodeViewData:
	var icon = node.get_level().get_info().roadmap_icon
	return LevelNodeViewData.of(node_id(node), node.get_position(), icon, node_state(node))


static func level_line(node: LevelTree.LevelNode, parent: LevelTree.LevelNode) -> LevelLineViewData:
	return LevelLineViewData.between(parent.get_position(), node.get_position(), node_state(node))


static func node_state(node: LevelTree.LevelNode) -> LevelNodeViewData.State:
	match node.get_state():
		LevelTree.NodeStates.PASSED:
			return LevelNodeViewData.State.PASSED
		LevelTree.NodeStates.UNLOCKED:
			return LevelNodeViewData.State.UNLOCKED
		_:
			return LevelNodeViewData.State.LOCKED

#endregion


#region player

static func resource_id(resource: Resource) -> StringName:
	return &"%d" % resource.get_instance_id()


static func item_of(accessory: Accessory) -> ItemViewData:

	if !accessory:
		return null

	var item_type = accessory.get_type()
	var icon = item_type.icon if item_type else null
	return ItemViewData.of(icon, _rarity(accessory.get_rarity()), _quality(accessory.get_quality()))


static func inventory(inventory: Inventory) -> Array[ItemViewData]:
	var items: Array[ItemViewData] = []
	for accessory in inventory.get_all():
		items.append(item_of(accessory))
	return items


static func treasure_items(treasure: Treasure) -> Array[ItemViewData]:
	var items: Array[ItemViewData] = []
	for accessory in treasure.get_items():
		items.append(item_of(accessory))
	return items


static func fish_entry(entry: Fishtiary.Entry) -> FishEntryViewData:
	var fish_type = entry.get_fish_type()
	return FishEntryViewData.of(resource_id(fish_type), fish_type.icon, fish_type.name, entry.is_unlocked())

#endregion


#region battle

static func question(question: Question, number: int) -> QuestionViewData:

	var question_type = question.get_type()
	var bank = question.get_question_bank()

	var variants: Array[String] = []
	variants.assign(question_type.answer_variants)

	return QuestionViewData.of(
		number,
		question_type.title,
		bank.name if bank else "",
		bank.color if bank else Color.WHITE,
		variants,
		question.get_timeout() if question.has_timeout() else -1
	)


static func answer_result(result: AnswerResult) -> AnswerResultViewData:
	return AnswerResultViewData.of(
		result.get_correct_answer_idx(),
		result.get_user_answer_idx(),
		result.is_correct()
	)


static func round_indicator(index: int, round_type: RoundType) -> RoundIndicatorViewData:
	var id = &"round_%d" % index
	return RoundIndicatorViewData.of(id, round_type.is_boss(), RoundIndicatorViewData.State.PENDING)

#endregion


#region private

static func _rarity(rarity: Accessory.Rarity) -> ItemViewData.Rarity:
	match rarity:
		Accessory.Rarity.RARE:
			return ItemViewData.Rarity.RARE
		Accessory.Rarity.EPIC:
			return ItemViewData.Rarity.EPIC
		Accessory.Rarity.LEGENDARY:
			return ItemViewData.Rarity.LEGENDARY
		_:
			return ItemViewData.Rarity.COMMON


static func _quality(quality: Accessory.Quality) -> ItemViewData.Quality:
	match quality:
		Accessory.Quality.GOOD:
			return ItemViewData.Quality.GOOD
		Accessory.Quality.BEST:
			return ItemViewData.Quality.BEST
		_:
			return ItemViewData.Quality.COMMON

#endregion
