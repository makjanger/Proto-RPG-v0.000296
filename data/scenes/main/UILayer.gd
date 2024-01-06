# UILayer.gd
extends CanvasLayer


@onready var main_ui: Control


func _ready() -> void:
    main_ui = %MainUI

    if is_instance_valid(main_ui) == false:
        assert(false, "MAIN UI NOT FOUND!")


func _unhandled_input(event: InputEvent) -> void:
    if GameManager.is_game_paused == false and event.is_action_pressed("ui_cancel"):
        get_tree().paused = true
        main_ui.show_hide_main_ui(false)
        get_viewport().set_input_as_handled()
        return
