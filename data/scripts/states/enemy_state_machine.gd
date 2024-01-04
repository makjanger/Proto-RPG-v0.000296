extends EnemyStateMachine


func ai_commands() -> void:
	match master_node.anim_player.current_animation:
		"hurt":
			await master_node.anim_player.hurt_animation_finished
			current_state.transition_to.emit(current_state, "EnemySelectState")
		"death":
			await master_node.anim_player.death_animation_finished
			current_state.transition_to.emit(current_state, "EnemySelectState")
		_:
			current_state.transition_to.emit(current_state, "EnemySelectState")


func take_damage() -> void:
	if master_node.stats.health <= 0:
		current_state.transition_to.emit(current_state, "EnemyDeathState")
	else:
		current_state.transition_to.emit(current_state, "EnemyHurtState")
