class_name RoundInfo extends Resource


#region enums

enum BattleTypes {
	## Default battle with weak or medium enemies
	COMMON,
	## Final battle with strong and hard to defeat enemy
	BOSS
}

#endregion


#region fields

@export var possible_enemy_types: Array[CharacterType]
@export var possible_loot: Array[AccessoryType]
@export var base_gold: int
@export var battle_type: BattleTypes
@export var associated_question_bank: QuestionBank

#endregion


#region getters/setters

func is_boss() -> bool:
	return battle_type == BattleTypes.BOSS

#endregion
