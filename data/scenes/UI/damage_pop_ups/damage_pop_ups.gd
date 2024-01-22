extends Node2D


@onready var anim_player := %AnimationPlayer
@onready var damage := %TextDamage


func _ready() -> void:
    anim_player.play("damage")


# func _physics_process(delta: float) -> void:
#     print(position)