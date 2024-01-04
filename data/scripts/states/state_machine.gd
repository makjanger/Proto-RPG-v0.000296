extends PlayerStateMachine


func activate() -> void:
	if current_state == null: return
		
	current_state.transition_to.emit(current_state, "IdleState")


func on_attack_button_pressed() -> void:
	current_state.on_attack_button_pressed()


func on_magic_button_pressed() -> void:
	pass


func take_damage() -> void:
	current_state.transition_to.emit(current_state, "HurtState")
