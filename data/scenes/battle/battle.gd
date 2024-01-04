# battle.gd
extends Node2D


@onready var player_positions: Array = %PlayerPositions.get_children()
@onready var enemy_positions: Array = %EnemyPositions.get_children()

@onready var battle_ui: Control = %BattleUI
@onready var main_menu: HBoxContainer = %MainMenuContainer
@onready var attack_button: Button = %AttackButton

var current_active_character : set = set_current_active_character

var all_characters: Array = []
var player_character_pool: Array = []
var enemy_character_pool: Array = []


func _ready() -> void:
	BattleManager.is_battle_over = false
	BattleManager.show_battle_ui.connect(_on_show_battle_ui)
	BattleManager.turn_end.connect(_on_turn_end)
	
	spawn_player_party()
	
	for enemy_position in enemy_positions:
		if enemy_position.get_child_count() > 0:
			enemy_character_pool.append(enemy_position.get_child(0))
			all_characters.append(enemy_position.get_child(0))
	
	sort_turn_order()
	current_active_character = all_characters[0]
	
	attack_button.grab_focus()


func spawn_player_party() -> void:
	var player_party := GameManager.player_party

	for member in player_party:
		for player_position in player_positions:
			if player_position.get_child_count() == 0:
				var new_member: Player = load(member.player_battle).instantiate()
				player_position.add_child(new_member)
				player_character_pool.append(new_member)
				all_characters.append(new_member)
				break


func sort_turn_order() -> void:
	all_characters.sort_custom(func(char_a, char_b) -> bool:
		return char_a.stats.agility > char_b.stats.agility)


func set_current_active_character(new_character) -> void:
	current_active_character = new_character
	print("Current active character: ", current_active_character)

	if current_active_character is Enemy:
		BattleManager.is_enemy_turn = true
		current_active_character.enemy_action()
	else:
		BattleManager.is_enemy_turn = false
		current_active_character.is_active_character = true


func _on_attack_button_pressed() -> void:
	battle_ui.hide()
	current_active_character.on_attack_button_pressed()
	get_viewport().set_input_as_handled()


func _on_escape_button_button_down() -> void:
	SceneStacker.pop()


func _on_show_battle_ui() -> void:
	battle_ui.show()
	attack_button.grab_focus()


func _on_turn_end() -> void:
	delete_defeated_characters()

	var previous_active_character = all_characters.pop_front()
	if enemy_character_pool.size() == 0:
		BattleManager.end_battle()
		return
	
	var character = all_characters[0]
	if is_instance_valid(character) == false:
		character = all_characters[0]

	current_active_character = character
	all_characters.append(previous_active_character)


func delete_defeated_characters() -> void:
	for died_character in all_characters:
		if is_instance_valid(died_character) == false:
			all_characters.erase(died_character)
	
	for died_character in player_character_pool:
		if is_instance_valid(died_character) == false:
			all_characters.erase(died_character)
	
	enemy_character_pool = get_tree().get_nodes_in_group("enemy")
