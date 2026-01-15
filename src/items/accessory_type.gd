class_name AccessoryType extends Resource


#region enums

enum AccessoryWearType {
	HEAD,
	BODY,
	LEGS
}

enum AccessoryRarity {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}

#endregion


#region fields

@export var icon: Texture2D
@export var behavior: AccessoryBehavior
@export var wearing: AccessoryWearType

#endregion
