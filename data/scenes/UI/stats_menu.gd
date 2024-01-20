class_name StatsMenu
extends Control


@onready var grey_x := preload("res://data/sprites/grey_x.png")
@onready var party_member_panel_scene := preload("res://data/scenes/UI/party_member_1.tscn")
@onready var equipment_slot_scene := preload("res://data/scenes/UI/equipment_slot_1.tscn")

@onready var party_member_slots: Array = %StatsVbox.get_children()
@onready var party_member_stats: VBoxContainer = %MemberStatsVbox

@onready var equipment_panel: PanelContainer = %EquipmentContainer

@onready var stats_avatar: TextureRect = %StatsAvatar
@onready var stats_basic_info: RichTextLabel = %BasicInfoLabel
@onready var stats_hp: RichTextLabel = %HPLabel
@onready var stats_hp_bar: ProgressBar = %HPBar
@onready var stats_full: RichTextLabel = %FullStatsLabel

@onready var main_hand_button: Button = %MainHandButton
var current_main_hand: Item:
	set(new_main_hand):
		current_main_hand = new_main_hand
		if current_main_hand == null:
			main_hand_button.icon = grey_x
		else:
			main_hand_button.icon = current_main_hand.texture

@onready var armor_button: Button = %ArmorButton
var current_armor: Item:
	set(new_armor):
		current_armor = new_armor
		if current_armor == null:
			armor_button.icon = grey_x
		else:
			armor_button.icon = current_armor.texture

var previous_party_member_selected: PartyMemberStats
var current_party_member_selected: PartyMemberStats

var focused_equipment: Button
var remove_equipment_input_events

var main_ui: MainUI


func _ready() -> void:
	disable_equipment_input_events()
	party_member_stats.hide()
	equipment_panel.hide()

	main_hand_button.focus_entered.connect(on_main_hand_button_focus_entered)
	armor_button.focus_entered.connect(on_armor_button_focus_entered)

	if not GameManager.is_game_ready:
		await GameManager.game_ready
	
	main_ui = get_parent()


func assign_party_members() -> void:
	var player_party: Array = GameManager.player_party

	if player_party.size() == party_member_slots.size():
		GameManager.check_stats.emit()
	else:
		for member: BasePlayer in %StatsVbox.get_children():
			%StatsVbox.remove_child(member)
			member.queue_free()
		
		for member: BasePlayer in player_party:
			var member_stats: PartyMemberStats = party_member_panel_scene.instantiate()
			%StatsVbox.add_child(member_stats)

			member_stats.party_member_focus_entered.connect(on_member_stats_button_focus_entered)

			member_stats.stats = member.stats
			member_stats.assign_stats()
			member_stats.button.pressed.connect(on_member_stats_pressed)
			party_member_slots.append(member_stats)


func on_member_stats_button_focus_entered(member_stats: PartyMemberStats) -> void:
	if current_party_member_selected == null:
		current_party_member_selected = member_stats
		return
	
	previous_party_member_selected = current_party_member_selected
	current_party_member_selected = member_stats


func on_member_stats_pressed() -> void:
	## Called from on_item_selected().
	if main_ui.inventory_menu.selected_slot:
		var item_effect: int = main_ui.inventory_menu.selected_slot.item.use(current_party_member_selected.stats)

		match item_effect:
			0: # Effect Denied
				main_ui.anim_player_1.play("shake_stats_in_inventory")
			1: # HEAL_HP
				pass
			2: # HEAL_MP
				pass
		
		GameManager.check_stats.emit()
			
		if !main_ui.inventory_menu.selected_slot.item:
			current_party_member_selected.button.release_focus()
			main_ui.anim_player_2.play("hide_item_description")
			await get_tree().create_timer(0.05).timeout
			main_ui.show_hide_main_ui(true)
			return

	else:
		main_ui.active_window = party_member_stats

		stats_avatar.texture = current_party_member_selected.sprite.texture
		stats_basic_info.text = current_party_member_selected.basic_info_text.text
		stats_hp.text = current_party_member_selected.health_label.text
		stats_hp_bar.value = current_party_member_selected.health_bar.value
		stats_hp_bar.max_value = current_party_member_selected.health_bar.max_value
		
		stats_full.text = "STRENGTH: %d\nAGILITY: %d\nINTELLIGENCE: %d" % \
		[current_party_member_selected.stats.strength,\
		current_party_member_selected.stats.agility,\
		current_party_member_selected.stats.intelligence]

		main_ui.anim_player_1.play("show_member_stats")
		
		enable_equipment_input_events()
		equipment_ui_update()

		main_hand_button.grab_focus()


func _on_main_hand_button_pressed() -> void:
	var player_inventory: Array[Item] = GameManager.player_inventory
	var equipment_panels: Array = equipment_panel.equipment_container.get_children()

	if equipment_panels.size() > 0:
		for child in equipment_panels:
			equipment_panel.equipment_container.remove_child(child)
			child.queue_free()

	for item: Item in player_inventory:
		if item.type == item.ItemType.EQUIPPABLE:
			var equipment_slot: EquipmentSlot = equipment_slot_scene.instantiate()
			equipment_slot.item = item
			equipment_panel.equipment_container.add_child(equipment_slot)
	
	
	main_ui.anim_player_1.play("show_equipment_menu")
	equipment_panel.on_equipment_container_shown()
	main_ui.active_window = equipment_panel


func _on_armor_button_pressed() -> void:
	pass # Replace with function body.


func on_main_hand_button_focus_entered() -> void:
	focused_equipment = main_hand_button


func on_armor_button_focus_entered() -> void:
	focused_equipment = armor_button


func equipment_ui_update() -> void:
	current_main_hand = current_party_member_selected.stats.main_hand
	current_armor = current_party_member_selected.stats.armor


func enable_equipment_input_events() -> void:
	for input_event in remove_equipment_input_events:
		InputMap.action_add_event("cancel", input_event)


func disable_equipment_input_events() -> void:
	remove_equipment_input_events = InputMap.action_get_events("cancel")
	InputMap.action_erase_events("cancel")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel") and \
	focused_equipment == main_hand_button:
		current_main_hand = null
		accept_event()
	
	if event.is_action_pressed("cancel") and \
	focused_equipment == armor_button:
		current_armor = null
		accept_event()
