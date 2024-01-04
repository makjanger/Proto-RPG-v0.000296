# SelectState.gd
extends State


var current_target: Node2D : set = set_current_target
var target_pool: Array

var current_target_index: int = 0


func init() -> void:
	set_process_unhandled_input(false)


func enter(_obj: Variant = null) -> void:
	print("SelectState entered: ", master_node)
	set_process_unhandled_input(true)

	target_pool = get_tree().get_nodes_in_group("enemy")

	if target_pool.size() == 1:
		current_target = target_pool[0]
		return

	current_target = target_pool[current_target_index]


func exit() -> void:
	master_node.arrow.hide()
	current_target.arrow.hide()
	set_process_unhandled_input(false)


func set_current_target(new_target) -> void:
	if current_target:
		current_target.arrow.hide()
	
	current_target = new_target
	current_target.arrow.show()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		if target_pool.size() - 1 < 0:
			return
		
		current_target_index -= 1

		if current_target_index < 0:
			current_target_index = target_pool.size() - 1
		
		current_target = target_pool[current_target_index]
		
		get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("right"):
		if target_pool.size() - 1 < 0:
			return
		
		current_target_index += 1

		if current_target_index > target_pool.size() - 1:
			current_target_index = 0
		
		current_target = target_pool[current_target_index]
		
		get_viewport().set_input_as_handled()

	if event.is_action_pressed("ui_accept"):
		transition_to.emit(self, "AttackState", current_target)
	
	if event.is_action_pressed("ui_cancel"):
		transition_to.emit(self, "IdleState")
