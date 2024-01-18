@tool
class_name Item
extends Resource


signal property_changed(property_name: String)


enum ItemType { CONSUMABLE = 1, EQUIPPABLE = 2 }
enum ItemConEffect { HEAL_HP = 1, HEAL_MP = 2 }
enum ItemEquEffect { DAMAGE_MODIFIER = 3 }
enum ItemEquType { MELEE = 331, RANGE = 332 }


@export var texture: Texture
@export var name: String
@export_multiline var description: String

@export var type: ItemType = ItemType.CONSUMABLE:
	set(new_type):
		type = new_type
		notify_property_list_changed()

@export var consumable_effect: ItemConEffect = ItemConEffect.HEAL_HP
@export var equippable_effect: ItemEquEffect = ItemEquEffect.DAMAGE_MODIFIER

@export_enum("MAIN HAND", "ARMOR") var equippable_slot := "MAIN HAND":
	set(new_equippable_slot):
		equippable_slot = new_equippable_slot
		notify_property_list_changed()

@export var attack_type: ItemEquType = ItemEquType.MELEE
@export var effect_strength: int = 1
@export var amount: int = 1: set = set_amount
@export var max_amount: int = 1: set = set_max_amount
@export var stackable: bool = false: set = set_stackable


func set_amount(new_amount: int) -> void:
	amount = new_amount

	if amount > 1:
		stackable = true

	property_changed.emit("item_amount")


func set_max_amount(new_max_amount: int) -> void:
	max_amount = new_max_amount

	if amount > max_amount:
		amount = max_amount


func set_stackable(new_stackable: bool) -> void:
	stackable = new_stackable

	if not stackable:
		amount = 1

	property_changed.emit("item_stackable")


func use(player_stats: PlayerStats) -> int:
	# print("{TYPE: ", type, "} {EFFECT: ", effect, "}")
	match type:
		ItemType.CONSUMABLE:
			match consumable_effect:
				ItemConEffect.HEAL_HP:
					if player_stats.health == player_stats.max_health:
						return 0
					
					player_stats.health += effect_strength
					amount -= 1
					return ItemConEffect.HEAL_HP

				ItemConEffect.HEAL_MP:
					return ItemConEffect.HEAL_MP

				_:
					printerr("ITEM TYPE DOES NOT MATCH ITEM EFFECT!!")
					return 0

		ItemType.EQUIPPABLE:
			match equippable_effect:
				ItemEquEffect.DAMAGE_MODIFIER:
					player_stats.main_hand = self
					print(player_stats.main_hand)
					return 0

				_:
					return 0
					
		_:
			return 0


func _validate_property(property: Dictionary) -> void:
	if property.name == "consumable_effect" \
	and type == ItemType.EQUIPPABLE:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	
	if property.name == "attack_type" \
	and type == ItemType.EQUIPPABLE and equippable_slot == "ARMOR":
		property.usage |= PROPERTY_USAGE_READ_ONLY

	if property.name == "equippable_effect" \
	and type == ItemType.CONSUMABLE:
		property.usage |= PROPERTY_USAGE_READ_ONLY

	if property.name == "attack_type" \
	and type == ItemType.CONSUMABLE:
		property.usage |= PROPERTY_USAGE_READ_ONLY

	if property.name == "equippable_slot" \
	and type == ItemType.CONSUMABLE:
		property.usage |= PROPERTY_USAGE_READ_ONLY
