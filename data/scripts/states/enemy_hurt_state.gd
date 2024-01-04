extends State


func enter(_obj: Variant = null) -> void:
	print("HurtState entered: ", master_node, "; HP = ", master_node.stats.health)
	master_node.anim_player.play("hurt")
	await master_node.anim_player.hurt_animation_finished
	transition_to.emit(self, "EnemyIdleState")
	
