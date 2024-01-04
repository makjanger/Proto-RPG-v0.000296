# game_manager.gd
extends Node


var player_party := []


func _ready() -> void:
    init_party()


func init_party() -> void:
    player_party = get_tree().get_nodes_in_group("active_player_party")
    