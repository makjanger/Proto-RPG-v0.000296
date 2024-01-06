class_name PlayerOverWorld
extends BasePlayer


const SPEED := 100.0
const FRICTION := 40.0


var direction: Vector2


func _physics_process(_delta: float) -> void:
	
	direction = Input.get_vector("left", "right", "up", "down")

	velocity.x = move_toward(velocity.x, direction.x * SPEED, FRICTION)
	velocity.y = move_toward(velocity.y, direction.y * SPEED, FRICTION)

	move_and_slide()


