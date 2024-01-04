# StateMachine.gd
class_name StateMachine
extends Node


@export var master_node: Node2D
@export var initial_state: State

var current_state: State

var states: Dictionary = {}


func _ready() -> void:
	var current_scene: Node = get_tree().root.find_child("Battle", true, false)
	await current_scene.ready

	if master_node == null:
		assert(false, "FATAL ERROR: No master node set!")

	for state: State in get_children():
		states[state.name.to_lower()] = state
		state.transition_to.connect(on_transitioning)
	
	
	if initial_state:
		current_state = initial_state
		current_state.enter()
	else:
		assert(false, "FATAL ERROR: No initial state set!")
		return
	
	init()


func init() -> void:
	pass


func on_transitioning(state: State, new_state_name: String, obj: Variant = null) -> void:
	if current_state != state:
		printerr("FATAL ERROR: State is wrong! ", current_state, " != ", state)
		return
	
	var new_state: State = states.get(new_state_name.to_lower())
	
	if !new_state:
		printerr("FATAL ERROR: State not found! ", new_state)
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state

	if obj:
		new_state.enter(obj)
	else:
		new_state.enter()


func take_damage() -> void:
	pass


func death() -> void:
	pass
 
