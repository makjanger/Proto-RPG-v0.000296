class_name BaseCharacter
extends Node2D


@export var sprite: Sprite2D
@export var anim_player: AnimationPlayer
@export var arrow: Node2D
@export var health_bar: ProgressBar

var is_scene_ready := false


func _ready() -> void:
	pre_initialize()

	var current_scene: Node = get_tree().root.find_child("Battle", true, false)
	await current_scene.ready
	is_scene_ready = true

	initialize()
	

func pre_initialize() -> void:
	pass


func initialize() -> void:
	pass


func death() -> void:
	pass
