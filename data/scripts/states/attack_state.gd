extends State


var tween: Tween


func enter(obj: Variant = null) -> void:
	print("AttackState entered: ", master_node, "; Enemy = ", obj)
	var initial_position: Vector2 = master_node.global_position 

	master_node.z_index = 100
	master_node.anim_player.stop()

	if obj:
		tween = create_tween()
		tween.tween_property(master_node, "global_position", obj.global_position - Vector2(16, 0), 0.5) \
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

		await tween.finished

		if obj.has_method("take_damage"):
			obj.take_damage(master_node.stats.strength + master_node.stats.damage_modifier)
		
		if obj.anim_player.current_animation == "death":
			await obj.anim_player.animation_finished
		
		tween = create_tween()
		tween.tween_property(master_node, "global_position", initial_position, 0.5) \
		.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

		await tween.finished
	else:
		return

	transition_to.emit(self, "AwaitState")


func exit() -> void:
	master_node.z_index = 0
	BattleManager.action_token -= 1

	if BattleManager.action_token <= 0:
		master_node.is_active_character = false
		BattleManager.reset_action_token()

	

