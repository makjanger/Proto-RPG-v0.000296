class_name BasePlayer
extends CharacterBody2D


@export var stats: PlayerStats
@export_file("*.tscn") var player_battle


func _ready() -> void:
    pre_initialize()

    initialize()


func pre_initialize() -> void:
    pass


func initialize() -> void:
    pass