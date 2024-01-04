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
	is_battle_over = true
	SceneStacker.pop()


func on_enemy_dies(enemy: Enemy) -> void:
	total_exp += enemy.stats.experience_points
	printerr("TOTAL EXP: ", total_exp)
