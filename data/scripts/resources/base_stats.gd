class_name BaseStats
extends Resource


@export var sprite: Texture
@export var name: String = "???"

@export var health: int = 100:
    set(new_health):
        health = new_health

        if health > max_health:
            health = max_health

@export var max_health: int = 100
@export var strength: int = 1
@export var agility: int = 1
@export var intelligence: int = 1