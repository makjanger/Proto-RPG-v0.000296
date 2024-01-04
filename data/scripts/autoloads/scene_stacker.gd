# scene_stacker.gd
extends Node


signal scene_changed()


var stack := []
var battle_scene_path := "res://data/scenes/battle/battle.tscn"


func push() -> void:
	var battle_scene: Node2D = load(battle_scene_path).instantiate()
	var tree := get_tree()
	var root := tree.root
	var current_scene := tree.current_scene

	stack.append(current_scene)

	root.remove_child(current_scene)
	root.add_child(battle_scene)

	tree.current_scene = battle_scene
	emit_signal("scene_changed")


func pop() -> void:
	if stack.is_empty(): return
	var tree := get_tree()
	var root := tree.root
	var previous_scene: Node = stack.pop_back()
	
	tree.current_scene.queue_free()
	
	root.add_child(previous_scene)
	tree.current_scene = previous_scene
	emit_signal("scene_changed")


func clear() -> void:
	for scene in stack:
		scene.queue_free()
	stack.clear()
