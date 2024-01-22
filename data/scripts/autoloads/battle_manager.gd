# battle_manager.gd
extends Node


signal show_battle_ui()
signal turn_end()
signal enemy_dies(enemy: Enemy)
signal battle_end()

var damage_number_scene := preload("res://data/scenes/UI/damage_pop_ups/damage_pop_ups.tscn")

var action_token := 1

var is_enemy_turn := false
var is_battle_over := false

var total_exp := 0
var total_level_up := 0


func _ready() -> void:
	enemy_dies.connect(on_enemy_dies)
	battle_end.connect(end_battle)


func reset_action_token() -> void:
	action_token = 1
	turn_end.emit()


func end_battle() -> void:
	printerr("BATTLE OVER!")
	total_exp = 0
	is_battle_over = true
	# assign_experience()
	SceneStacker.pop()


func assign_experience() -> void:
	var player_party := get_tree().get_nodes_in_group("player")

	for member: Player in player_party:
		member.stats.experience += total_exp
	
	total_exp = 0


func on_enemy_dies(enemy: Enemy) -> void:
	total_exp += enemy.stats.experience_points
	printerr("TOTAL EXP: ", total_exp)


func pop_up_damage(character: BaseCharacter, damage: int) -> void:
	var tween := create_tween()
	var damage_pop_up: Node2D = damage_number_scene.instantiate()

	var rand_x := randi_range(-32, 32)
	var rand_y := randi_range(-32, 0)

	var direction := Vector2(rand_x, rand_y)

	# print(direction)

	# tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	get_tree().current_scene.add_child(damage_pop_up)
	damage_pop_up.position = character.global_position - Vector2(0, 36)
	damage_pop_up.damage.text = str("[center]",damage)

	tween.tween_property(damage_pop_up, "position", direction, 1.0).as_relative()
	await tween.finished
