## Builds the roadmap and knows how to query/mutate its level tree.
class_name RoadmapManager extends RefCounted


#region fields

var _roadmap: Roadmap

#endregion


#region public

## Generates a brand new roadmap out of the passed generation info.
func generate(info: RoadmapGenerationInfo) -> Roadmap:
	var roadmap = Roadmap.of(info.roadmap_info)
	info.roadmap_generator.generate(info.roadmap_depth, roadmap)
	_roadmap = roadmap
	return roadmap


func roadmap() -> Roadmap:
	return _roadmap


func level_tree() -> LevelTree:
	return _roadmap.get_level_tree() if _roadmap else null


func find_node_by_level(level: Level) -> LevelTree.LevelNode:
	return _find_node_recursive(level_tree().get_root(), level)


## Finds the first playable node, so a presenter can zoom camera on it.
func find_first_unlocked_node() -> LevelTree.LevelNode:
	return _find_unlocked_recursive(level_tree().get_root())


func mark_passed(node: LevelTree.LevelNode) -> void:
	node.pass_()

#endregion


#region private

func _find_node_recursive(node: LevelTree.LevelNode, level: Level) -> LevelTree.LevelNode:

	if !node:
		return null

	if node.get_level() == level:
		return node

	for child in node.get_children():
		var found = _find_node_recursive(child, level)
		if found:
			return found

	return null


func _find_unlocked_recursive(node: LevelTree.LevelNode) -> LevelTree.LevelNode:

	if !node:
		return null

	if node.is_unlocked():
		return node

	for child in node.get_children():
		var found = _find_unlocked_recursive(child)
		if found:
			return found

	return null

#endregion
