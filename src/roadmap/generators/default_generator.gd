## Default level generator. It generates roadmap with single (critical) path.
## The form of roadmap path is vertical wave-like form.
class_name DefaultGenerator extends RoadmapGenerator


#region constants

const NODE_PADDING = 5
const NODE_WAVE_AMPLITUDE = 2

#endregion


#region fields

var _max_depth: int
var _tilemap: TileMapLayer
var _level_type_pool: LevelTypePool

#endregion


#region abstract

func generate(roadmap: Roadmap) -> void:
	var level_tree = roadmap.get_level_tree()

	_max_depth = roadmap.get_level_amount()
	_tilemap = roadmap.get_tilemap()
	_level_type_pool = roadmap.get_level_type_pool()

	var root_level_type = _level_type_pool.get_next()
	var root_level = Level.of(0, root_level_type)
	var root = level_tree.create_root(root_level, Vector2i.ZERO)

	_rec_generate(root, 1, 1)

#endregion


#region private

func _rec_generate(root: LevelTree.LevelNode, direction: int, depth: int) -> void:
	if depth > _max_depth:
		return
	
	var level_type = _level_type_pool.get_next()
	var level = Level.of(depth, level_type)
	var position = Vector2i(
		direction * NODE_WAVE_AMPLITUDE + randi_range(2, 10),
		depth * NODE_PADDING)

	var global_position = _tilemap.map_to_local(position)
	root = root.create_child(level, global_position)
	_rec_generate(root, -direction, depth + 1)

#endregion
