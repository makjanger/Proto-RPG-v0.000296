class_name PartyMemberBattleResult
extends PanelContainer


signal button_confirmed(exp_amount: int)
signal level_up(character: PartyMemberBattleResult)
signal animation_finished()

@onready var player_tex: TextureRect = %TextureSprite
@onready var level_label: Label = %LevelLabel
@onready var exp_label: Label = %ExperienceLabel
@onready var exp_bar: ProgressBar = %ExperienceBar

var level: int:
    set(new_level):
        printerr("LEVEL UP!")
        level = new_level

        level_label.text = "LEVEL: %d" % [level]

var max_exp: int:
    set(new_max_exp):
        max_exp = new_max_exp
        exp_bar.max_value = max_exp
        exp_label.text = "EXP: 0/%d" % \
        [max_exp]

var tween: Tween
var index: int


func _ready() -> void:
    button_confirmed.connect(_on_button_confirmed)


func _on_button_confirmed(exp_amount: int) -> void:
    if exp_amount == 0:
        tween.stop()
        animation_finished.emit()
        return
    
    tween = create_tween()
    var duration: float = exp_amount * 0.05

    tween.tween_property(exp_bar, "value", exp_amount, duration)

    await tween.finished
    animation_finished.emit()

func _on_experience_bar_value_changed(value:float) -> void:
    var int_value := int(value)
    printerr("CALLED ", value)

    exp_label.text = "EXP: %d/%d" % [int_value, max_exp]

    match int_value:
        max_exp:
            tween.stop()
            exp_bar.value = 0
            level_up.emit(self)
        _:
            exp_bar.value = int_value
