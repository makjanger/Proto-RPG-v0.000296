extends State


func enter(_obj: Variant = null) -> void:
	print("IdleState entered: ", master_node)

	var random_frame := randf_range(0.0, 1.0)

	master_node.anim_player.play("idle")
	master_node.anim_player.seek(random_frame)
	master_node.arrow.hide()


func take_damage() -> void:
	transition_to.emit(self, "EnemyHurtState")
