# main.gd
extends Node2D


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("g"):
		SceneStacker.push()
