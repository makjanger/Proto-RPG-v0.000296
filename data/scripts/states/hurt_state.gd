extends State


func enter(_obj: Variant = null) -> void:
	print("HurtState entered: ", master_node, "; HP = ", master_node.stats.health)
	if master_node is Player:
		master_node.anim_player.play("hurt")
		await master_node.anim_player.animation_finished

		if BattleManager.is_enemy_turn \
		or !master_node.is_active_character:
			transition_to.emit(self, "AwaitState")
		elif master_node.is_active_character:
			transition_to.emit(self, "IdleState")
