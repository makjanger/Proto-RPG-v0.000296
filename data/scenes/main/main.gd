# main.gd
extends Node2D


@onready var anim_player: AnimationPlayer = %MainAnimationPlayer
@onready var dark_bg: TextureRect = %DarkBG

var is_ready := false


func _ready() -> void:
	dark_bg.hide()
	is_ready = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("g"):
		get_tree().paused = true
		anim_player.play("scene_exited")
		await anim_player.animation_finished
		SceneStacker.push()


func _on_tree_entered() -> void:
	print("SCENE ENTERED")

	if not is_ready:
		await ready

	anim_player.play("scene_entered")
	await anim_player.animation_finished
	get_tree().paused = false


func _on_tree_exited() -> void:
	pass # Replace with function body.

