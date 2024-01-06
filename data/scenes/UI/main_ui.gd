extends Control


@onready var anim_player: AnimationPlayer = %AnimationPlayer

@onready var base_menu := %BaseMenuContainer

@onready var inventory_menu := %InventoryContainer
@onready var item_slots: Array = %InventoryGrid.get_children()

@onready var party_member_panel := preload("res://data/scenes/UI/party_member_1.tscn")
@onready var stats_menu := %StatsContainer
@onready var party_member_slots: Array = %StatsVbox.get_children()

@onready var main_buttons: Array = %BaseMenuVbox.get_children()
@onready var resume_button := %ResumeButton
@onready var inventory_button := %InventoryButton
@onready var stats_button := %StatsButton
@onready var option_button := %OptionButton
@onready var exit_button := %ExitButton

var active_window: Node = null


func _ready() -> void:
    base_menu.hide()
    inventory_menu.hide()
    stats_menu.hide()


func _unhandled_input(event: InputEvent) -> void:
    if base_menu.visible and event.is_action_pressed("ui_cancel"):
        show_hide_main_ui(base_menu.visible)
    
    if !base_menu.visible and event.is_action_pressed("ui_cancel"):
        show_hide_main_ui(base_menu.visible)


func _on_resume_button_button_down() -> void:
    show_hide_main_ui(true)


func _on_inventory_button_button_down() -> void:
    active_window = inventory_menu
    anim_player.play("show_inventory_menu")
    item_slots[0].button.grab_focus()
    await anim_player.animation_finished
    

func _on_stats_button_button_down() -> void:
    active_window = stats_menu

    var player_party: Array = GameManager.player_party

    if player_party.size() == party_member_slots.size():
        GameManager.check_stats.emit()
    else:
        for member: BasePlayer in %StatsVbox.get_children():
            %StatsVbox.remove_child(member)
            member.queue_free()

        for member: BasePlayer in player_party:
            var foo := party_member_panel.instantiate()
            %StatsVbox.add_child(foo)
            foo.stats = member.stats
            foo.assign_stats()
            party_member_slots.append(foo)
    
    anim_player.play("show_stats_menu")
    party_member_slots[0].button.grab_focus()
    await anim_player.animation_finished
    

func _on_option_button_button_down() -> void:
    pass # Replace with function body.
                
                
func _on_exit_button_button_down() -> void:
    get_tree().quit()
    accept_event()
                    
                    
func show_hide_main_ui(is_ui_visible: bool) -> void:
    if anim_player.is_playing(): return
    
    match active_window:
        null:
            if !is_ui_visible:
                anim_player.play("show_base_menu")
                active_window = base_menu
                await anim_player.animation_finished
        
        base_menu:
            if is_ui_visible:
                remove_button_focus()
                anim_player.play("hide_base_menu")
                active_window = null
                await anim_player.animation_finished
                GameManager.is_game_paused = false
                get_tree().paused = false
        
        inventory_menu:
            active_window = base_menu
            anim_player.play("hide_inventory_menu")
        
        stats_menu:
            active_window = base_menu
            anim_player.play("hide_stats_menu")

    accept_event()
    return


func remove_button_focus() -> void:
    for button: Button in main_buttons:
        button.release_focus()


func main_buttons_focus_controller(state: bool) -> void:
    for button: Button in main_buttons:
        match state:
            true:
                button.focus_mode = Control.FOCUS_ALL
            false:
                button.focus_mode = Control.FOCUS_NONE