## Static-ish configuration of a singleplayer game: everything the old
## screens used to hardcode (test resources, starting character) lives here.
class_name GameConfig extends RefCounted


#region constants

#FIXME - generation info should be read from question packs, loaded via our website
const DEFAULT_GENERATION_INFO = preload("uid://cmwa7rcn5lud2")

#FIXME - character should be selected in special screen
const DEFAULT_CHARACTER_TYPE = preload("uid://cruifhqw6ohqc")

## Registry path of the group where all fish types are registered
const FISH_TYPES_REGISTRY_PATH = "resources.fish_types"

## Registry path of the group where all screens are registered
const SCREENS_REGISTRY_PATH = "scenes.screens"

#endregion


#region fields

var generation_info: RoadmapGenerationInfo = DEFAULT_GENERATION_INFO
var character_type: CharacterType = DEFAULT_CHARACTER_TYPE

#endregion


#region public

## Collects every fish type known to the game, so a new session
## starts with a full (locked) fishtiary.
func collect_fish_types() -> Array[FishType]:
	var fish_types: Array[FishType] = []
	fish_types.assign(Registry.get_all(FISH_TYPES_REGISTRY_PATH))
	return fish_types

#endregion
