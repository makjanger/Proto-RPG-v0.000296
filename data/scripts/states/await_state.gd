extends State


func enter(_obj: Variant = null) -> void:
	print("AwaitState entered: ", master_node)
	master_node.anim_player.play("idle")
	master_node.arrow.hide()
	
	if BattleManager.is_enemy_turn == false \
	and BattleManager.is_battle_over == false \
	and master_node.is_active_character == true:
		transition_to.emit(self, "IdleState")
