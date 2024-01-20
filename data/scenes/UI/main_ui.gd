class_name MainUI
extends Control


@onready var anim_player_1: AnimationPlayer = %AnimationPlayer1
@onready var anim_player_2: AnimationPlayer = %AnimationPlayer2

@onready var base_menu: BaseMenu = %BaseMenu
@onready var inventory_menu: InventoryMenu = %InventoryMenu
@onready var stats_menu: StatsMenu = %StatsMenu

var active_window: Node = null

var is_ready: bool = false


func _ready() -> void:
	base_menu.hide()
	inventory_menu.hide()
	stats_menu.hide()

	is_ready = true


func _unhandled_input(event: InputEvent) -> void:
	if base_menu.visible and event.is_action_pressed("ui_cancel"):
		show_hide_main_ui(base_menu.visible)
	
	if !base_menu.visible and event.is_action_pressed("ui_cancel"):
		show_hide_main_ui(base_menu.visible)


func show_hide_main_ui(is_ui_visible: bool) -> void:
	if anim_player_1.is_playing(): return
	if !get_node("/root/Main").first_init_ready:
		await get_node("/root/Main").first_init
	
	match active_window:
		null:
			if !is_ui_visible:
				anim_player_1.play("show_base_menu")
				active_window = base_menu
				await anim_player_1.animation_finished
		
		base_menu:
			if is_ui_visible:
				base_menu.remove_button_focus()
				anim_player_1.play("hide_base_menu")
				active_window = null
				await anim_player_1.animation_finished
				GameManager.is_game_paused = false
				get_tree().paused = false
		
		inventory_menu:
			active_window = base_menu
			inventory_menu.selected_slot = null
			inventory_menu.previous_selected_slot = null
			stats_menu.current_party_member_selected = null
			anim_player_2.play("hide_item_description")
			anim_player_1.play("hide_inventory_menu")
		
		stats_menu:
			if inventory_menu.is_visible_in_tree():
				active_window = inventory_menu
				stats_menu.current_party_member_selected = null
				stats_menu.previous_party_member_selected = null
				anim_player_1.play("hide_stats_in_inventory")
				await get_tree().create_timer(0.01).timeout
				inventory_menu.selected_slot.button.grab_focus()

			else:
				active_window = base_menu
				stats_menu.current_party_member_selected = null
				anim_player_1.play("hide_stats_menu")
		
		stats_menu.party_member_stats:
			active_window = stats_menu
			stats_menu.disable_equipment_input_events()
			stats_menu.focused_equipment = null
			anim_player_1.play("show_stats_menu")
			stats_menu.current_party_member_selected.button.grab_focus()
		
		stats_menu.equipment_panel:
			active_window = stats_menu
			anim_player_1.play("hide_equipment_menu")
	
	accept_event()
	return

