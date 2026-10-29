class_name Roadmap extends Node2D


#region constants

const DEFAULT_TILEMAP_SIZE = 16

#endregion


#region fields

var _level_tree: LevelTree
var _level_type_pool: LevelTypePool

#endregion


#region builtins

func _init(info: RoadmapInfo) -> void:
	_level_tree = LevelTree.new()
	_level_type_pool = info.level_type_pool

#endregion


#region getters/setters

func get_tilemap_size() -> int:
	return DEFAULT_TILEMAP_SIZE


func tilemap_to_global(coord: Vector2i) -> Vector2:
	return Vector2(coord * DEFAULT_TILEMAP_SIZE)


func get_level_tree() -> LevelTree:
	return _level_tree


func get_level_type_pool() -> LevelTypePool:
	return _level_type_pool

#endregion


#region static

static func of(info: RoadmapInfo) -> Roadmap:
	return Roadmap.new(info)

#endregion
