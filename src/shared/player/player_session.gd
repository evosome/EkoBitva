class_name PlayerSession


#region fields

var _character_type: CharacterType
var _inventory: Inventory
var _fishtiary: Fishtiary
var _roadmap: Roadmap
var _level_result_map: Dictionary[Level, LevelResult]

#endregion


#region builtins

func _init(
    character_type: CharacterType,
    inventory: Inventory,
    fishtiary: Fishtiary,
    roadmap: Roadmap
) -> void:

    _character_type = character_type
    _inventory = inventory
    _fishtiary = fishtiary
    _roadmap = roadmap

#endregion


#region getters/setters

func get_character_type() -> CharacterType:
    return _character_type


func get_inventory() -> Inventory:
      return _inventory


func get_fishtiary() -> Fishtiary:
      return _fishtiary


func get_roadmap() -> Roadmap:
      return _roadmap


func get_last_result_of(level: Level) -> LevelResult:
      return _level_result_map[level]


func add_level_result(level: Level, result: LevelResult) -> void:
      _level_result_map[level] = result

#endregion
