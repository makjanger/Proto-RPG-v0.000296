class_name Player
extends BaseCharacter


@export var stats: PlayerStats : set = set_stats
@export var state_machine: PlayerStateMachine

var is_active_character := false : set = set_is_active_character


func pre_initialize() -> void:
	if stats == null:
		assert(false, "Player stats not set")


func initialize() -> void:
	stats = stats


func on_attack_button_pressed() -> void:
	state_machine.on_attack_button_pressed()


func calculate_damage() -> int:
	var damage := roundi(2 * (stats.strength + stats.agility))
	print("Total damage dealt: ", damage)
	return damage


func take_damage(damage: int) -> void:
	set_health(stats.health - damage)
	state_machine.take_damage()


func set_stats(new_stats: PlayerStats) -> void:
	stats = new_stats
	
	if is_scene_ready == false: return
	
	set_health(stats.health)
	set_max_health(stats.max_health)


func get_stats() -> BaseStats:
	return stats


func set_health(new_health: int) -> void:
	stats.health = new_health
	health_bar.value = stats.health
	
	if stats.health <= 0:
		death()


func set_max_health(new_max_health: int) -> void:
	stats.max_health = new_max_health
	health_bar.max_value = stats.max_health


func set_is_active_character(is_active: bool) -> void:
	is_active_character = is_active
	
	if is_active_character == true:
		state_machine.activate()
