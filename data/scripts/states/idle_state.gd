# IdleState.gd
extends State


func enter(_obj: Variant = null) -> void:
	print("IdleState entered: ", master_node)

	master_node.anim_player.play("idle")
	master_node.arrow.show()
	BattleManager.show_battle_ui.emit()


func exit() -> void:
	master_node.arrow.hide()


func on_attack_button_pressed() -> void:
	transition_to.emit(self, "SelectState")
