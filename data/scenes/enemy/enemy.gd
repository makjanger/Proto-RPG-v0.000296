class_name Enemy
extends BaseCharacter


@export var stats: EnemyStats : set = set_stats
@export var state_machine: EnemyStateMachine


func pre_initialize() -> void:
	if stats == null:
		assert(false, "Enemy stats not set")


func initialize() -> void:
	stats = stats


func calculate_damage() -> int:
	var damage := roundi(2 * (stats.strength + stats.agility))
	print("Total damage dealt: ", damage)
	return damage


func take_damage(damage: int) -> void:
	set_health(stats.health - damage)
	BattleManager.pop_up_damage(self, damage)
	state_machine.take_damage()


func set_stats(new_stats: EnemyStats) -> void:
	stats = new_stats
	
	if is_scene_ready == false: return
	
	set_health(stats.health)
	set_max_health(stats.max_health)


func get_stats() -> BaseStats:
	return stats


func set_health(new_health: int) -> void:
	stats.health = new_health
	health_bar.value = stats.health
	
	if stats.health < 0:
		stats.health = 0


func set_max_health(new_max_health: int) -> void:
	stats.max_health = new_max_health
	health_bar.max_value = stats.max_health


func enemy_action() -> void:
	state_machine.ai_commands()


func death() -> void:
	state_machine.death()
