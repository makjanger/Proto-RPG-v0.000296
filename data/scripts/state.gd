class_name State extends Node


signal transition_to(from: State, to: State, obj: Variant)

@export var master_node: Node


func _ready() -> void:
	if !master_node:
		assert(false, "FATAL ERROR: Master Node not found!")
		return
	
	init()


func init() -> void:
	pass


func enter(_obj: Variant = null) -> void:
	pass


func exit() -> void:
	pass


func take_damage() -> void:
	pass
