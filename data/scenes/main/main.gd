# main.gd
extends Node2D


signal first_init()

@onready var anim_player: AnimationPlayer = %MainAnimationPlayer
@onready var dark_bg: TextureRect = %DarkBG

var first_init_ready := false


func _ready() -> void:
	dark_bg.show()
	GameManager.is_game_ready = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("g"):
		get_tree().paused = true
		anim_player.play("scene_exited")
		await anim_player.animation_finished
		SceneStacker.push()


func _on_tree_entered() -> void:
	print("SCENE ENTERED")

	if not GameManager.is_game_ready:
		await GameManager.game_ready

	anim_player.play("scene_entered")
	await anim_player.animation_finished
	get_tree().paused = false
	
	if !first_init_ready:
		first_init_ready = true
		first_init.emit()


func _on_tree_exited() -> void:
	pass # Replace with function body.

