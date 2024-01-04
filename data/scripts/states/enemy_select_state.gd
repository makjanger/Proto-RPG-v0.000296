extends State


var current_target: Node2D
var target_pool: Array


func enter(_obj: Variant = null) -> void:
	print("SelectState entered: ", master_node)
	target_pool = get_tree().get_nodes_in_group("player")
	current_target = target_pool[0]
	transition_to.emit(self, "EnemyAttackState", current_target)

