extends State


func enter(_obj: Variant = null) -> void:
	master_node.health_bar.hide()
	master_node.anim_player.play("death")
	await master_node.anim_player.animation_finished
	master_node.queue_free()
	BattleManager.enemy_dies.emit(master_node)
