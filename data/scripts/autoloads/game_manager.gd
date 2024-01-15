# game_manager.gd
extends Node


signal check_stats()


@onready var minor_health_potion: Item = preload("res://data/items/consumable/minor_healing_potion.tres")
@onready var sword: Item = preload("res://data/items/equippable/sword.tres")

var player_party := []

var player_inventory: Array[Item]

var is_game_paused:= false


func _ready() -> void:
    init_party()
    player_inventory.append(minor_health_potion)
    player_inventory.append(sword)


func init_party() -> void:
    player_party = get_tree().get_nodes_in_group("active_player_party")
    