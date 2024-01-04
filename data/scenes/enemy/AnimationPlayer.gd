extends AnimationPlayer


signal hurt_animation_finished
signal death_animation_finished


func _ready() -> void:
	animation_finished.connect(on_animation_finished)


func on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		hurt_animation_finished.emit()
	elif anim_name == "death":
		death_animation_finished.emit()
