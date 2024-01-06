# battle_manager.gd
extends Node


signal show_battle_ui()
signal turn_end()
signal enemy_dies(enemy: Enemy)


var action_token := 1

var is_enemy_turn := false
var is_battle_over := false

var total_exp := 0


func _ready() -> void:
	enemy_dies.connect(on_enemy_dies)


func reset_action_token() -> void:
	action_token = 1
	turn_end.emit()


func end_battle() -> void:
	printerr("BATTLE OVER!")
	is_battle_over = true
	assign_experience()
	SceneStacker.pop()


func assign_experience() -> void:
	var player_party := get_tree().get_nodes_in_group("player")

	for member: Player in player_party:
		member.stats.experience += total_exp
	
	total_exp = 0


func on_enemy_dies(enemy: Enemy) -> void:
	total_exp += enemy.stats.experience_points
	printerr("TOTAL EXP: ", total_exp)
