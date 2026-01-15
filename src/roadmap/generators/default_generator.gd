## Default level generator. It generates roadmap with single (critical) path.
## The form of roadmap path is vertical wave-like form.
class_name DefaultGenerator extends RoadmapGenerator


#region constants

const NODE_PADDING = 2
const NODE_WAVE_AMPLITUDE = 2

#endregion


#region fields

var _max_depth: int

#endregion


#region abstract

func generate(roadmap: Roadmap) -> void:
    var level_tree = roadmap.get_level_tree()
    var root_node = level_tree.get_root()

    _max_depth = 0

    _rec_generate(root_node, 1, 0)

#endregion


#region private

func _rec_generate(root: LevelTree.LevelNode, direction: int, depth: int) -> void:
    if depth > _max_depth:
        return
    
    var level = Level.of(depth, null)
    var position = Vector2i(direction * NODE_WAVE_AMPLITUDE, depth + NODE_PADDING)

    root = root.create_child(level, position)
    _rec_generate(root, -direction, depth + 1)

#endregion
