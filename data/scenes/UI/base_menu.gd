class_name BaseMenu
extends Control


signal button_pressed(button: Button)

@onready var resume_button: Button = %ResumeButton
@onready var inventory_button: Button = %InventoryButton
@onready var stats_button: Button = %StatsButton
@onready var option_button: Button = %OptionButton
@onready var exit_button: Button = %ExitButton

var all_buttons: Array[Button]
var main_ui: MainUI


func _ready() -> void:
	all_buttons.append(resume_button)
	all_buttons.append(inventory_button)
	all_buttons.append(stats_button)
	all_buttons.append(option_button)
	all_buttons.append(exit_button)

	if not GameManager.is_game_ready:
		await GameManager.game_ready
	
	main_ui = get_parent()


func _on_resume_button_pressed() -> void:
	print("resume_button pressed.")
	main_ui.show_hide_main_ui(true)


func _on_inventory_button_pressed() -> void:
	print("inventory_button pressed.")
	main_ui.active_window = main_ui.inventory_menu

	for item_slot: ItemSlot in main_ui.inventory_menu.item_slots:
		if item_slot.item: continue
		if not item_slot.enable: continue
		if not GameManager.player_inventory: continue

		item_slot.item = GameManager.player_inventory.pop_front()

	main_ui.anim_player_1.play("show_inventory_menu")
	main_ui.inventory_menu.item_slots[0].button.grab_focus()
	await main_ui.anim_player_1.animation_finished


func _on_stats_button_pressed() -> void:
	print("stats_button pressed.")

	main_ui.active_window = main_ui.stats_menu
		
	main_ui.stats_menu.assign_party_members()
	
	main_ui.anim_player_1.play("show_stats_menu")
	main_ui.stats_menu.party_member_slots[0].button.grab_focus()
	await main_ui.anim_player_1.animation_finished


func _on_option_button_pressed() -> void:
	print("option_button pressed.")
	pass


func _on_exit_button_pressed() -> void:
	print("exit_button pressed")
	get_tree().quit()


func remove_button_focus() -> void:
	for button: Button in all_buttons:
		button.release_focus()


func main_buttons_focus_controller(state: bool) -> void:
	for button: Button in all_buttons:
		match state:
			true:
				button.disabled = false
				button.focus_mode = Control.FOCUS_ALL
			false:
				button.disabled = true
				button.focus_mode = Control.FOCUS_NONE
