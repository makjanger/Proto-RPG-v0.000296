# game_manager.gd
extends Node


signal check_stats()


var player_party := []

var is_game_paused:= false


func _ready() -> void:
    init_party()


func init_party() -> void:
    player_party = get_tree().get_nodes_in_group("active_player_party")
    