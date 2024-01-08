class_name Item
extends Resource


signal property_changed(property_name: String)


enum ItemType { CONSUMABLE, EQUIPPABLE }
enum ItemEffect { HEAL_HP, HEAL_MP}


@export var texture: Texture
@export var name: String
@export_multiline var description: String
@export var type: ItemType = ItemType.CONSUMABLE
@export var effect: ItemEffect = ItemEffect.HEAL_HP
@export var effect_strength: int = 1
@export var amount: int = 1: set = set_amount
@export var stackable: bool = false: set = set_stackable


func set_amount(new_amount: int) -> void:
    amount = new_amount

    if amount > 1:
        stackable = true

    property_changed.emit("item_amount")


func set_stackable(new_stackable: bool) -> void:
    stackable = new_stackable

    if not stackable:
        amount = 1

    property_changed.emit("item_stackable")


func use() -> int:
    match type:
        ItemType.CONSUMABLE:
            match effect:
                ItemEffect.HEAL_HP:
                    return effect_strength
                ItemEffect.HEAL_MP:
                    return effect_strength
                _:
                    return 0
        ItemType.EQUIPPABLE:
            return 0
        _:
            return 0