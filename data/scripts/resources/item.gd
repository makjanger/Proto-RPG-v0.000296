@tool
class_name Item
extends Resource


signal property_changed(property_name: String)


enum ItemType { CONSUMABLE = 1, EQUIPPABLE = 2 }
enum ItemEffect { HEAL_HP = 1, HEAL_MP = 2}


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


func use(player_stats: PlayerStats) -> int:
    print("{TYPE: ", type, "} {EFFECT: ", effect, "}")
    match type:
        ItemType.CONSUMABLE:
            match effect:
                ItemEffect.HEAL_HP:
                    if player_stats.health == player_stats.max_health:
                        return 0
                    
                    player_stats.health += effect_strength
                    amount -= 1
                    return ItemEffect.HEAL_HP
                ItemEffect.HEAL_MP:
                    return ItemEffect.HEAL_MP
                _:
                    return 0
        ItemType.EQUIPPABLE:
            return 0
        _:
            return 0
