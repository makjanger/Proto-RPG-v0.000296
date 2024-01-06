class_name PartyMemberStats
extends PanelContainer


@onready var sprite: TextureRect = %TextureSprite
@onready var basic_info_text: RichTextLabel = %BasicInfoText
@onready var health_label: RichTextLabel = %HealthLabel
@onready var health_bar: ProgressBar = %HealthBar
@onready var button: Button = %StatsButton

var stats: PlayerStats


func _ready() -> void:
    GameManager.check_stats.connect(assign_stats)


func assign_stats() -> void:
    sprite.texture = stats.sprite

    basic_info_text.text = "%s\nLevel: %d\nEXP: %d\nNEXT: %d" % \
    [stats.name, stats.level, stats.experience, stats.max_experience]

    health_bar.max_value = stats.max_health
    health_bar.value = stats.health
    health_label.text = "HP: %d/%d" % [stats.health, stats.max_health]