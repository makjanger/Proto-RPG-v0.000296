# game_manager.gd
extends Node


signal game_ready()
signal check_stats()

@onready var minor_health_potion: Item = preload("res://data/items/consumable/minor_healing_potion.tres")
@onready var sword: Item = preload("res://data/items/equippable/sword.tres")
@onready var great_sword: Item = preload("res://data/items/equippable/great_sword.tres")

var player_party := []

var player_inventory: Array[Item]

var is_game_ready := false:
    set(new_state):
        is_game_ready = new_state
        if is_game_ready == true:
            game_ready.emit()          
var is_game_paused := false


func _ready() -> void:
    init_party()
    player_inventory.append(minor_health_potion)
    player_inventory.append(sword)
    player_inventory.append(great_sword)
    player_inventory.append(sword)
    player_inventory.append(great_sword)
    player_inventory.append(sword)
    player_inventory.append(great_sword)


func init_party() -> void:
    player_party = get_tree().get_nodes_in_group("active_player_party")
    