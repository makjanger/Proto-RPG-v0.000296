class_name PlayerStats
extends BaseStats


@export var level: int = 1 : set = set_level
@export var experience: int = 0 : set = set_experience
@export var max_experience: int = 100 : set = set_max_experience


func set_level(new_level: int) -> void:
    level = new_level
    max_experience += roundi(max_experience * 1.1)

    strength += 1
    agility += 1
    intelligence += 1

    max_health += 10


func set_experience(new_experience: int) -> void:
    experience = new_experience
    if experience >= max_experience:
        experience = 0
        level += 1


func set_max_experience(new_max_experience: int) -> void:
    max_experience = new_max_experience