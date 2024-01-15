class_name PlayerStats
extends BaseStats


signal equipment_changed(equipment: Item)

@export var level: int = 1 : set = set_level
@export var experience: int = 0 : set = set_experience
@export var max_experience: int = 100 : set = set_max_experience

var exp_remainder: int

@export var main_hand: Item: set = set_main_hand
@export var armor: Item: set = set_armor


func set_level(new_level: int) -> void:
	if level == new_level: return
	
	level = new_level
	max_experience = roundi(max_experience * 1.1)
	
	strength += 1
	agility += 1
	intelligence += 1

	max_health += 10


func set_experience(new_experience: int) -> void:
	if experience == new_experience: return

	experience += new_experience

	if experience >= max_experience:
		exp_remainder = experience - max_experience
		experience = 0
		level += 1
	elif experience < max_experience:
		exp_remainder = 0


func set_max_experience(new_max_experience: int) -> void:
	max_experience = new_max_experience


func set_main_hand(new_main_hand: Item) -> void:
	main_hand = new_main_hand
	equipment_changed.emit(main_hand)


func set_armor(new_armor: Item) -> void:
	armor = new_armor
	equipment_changed.emit(armor)
