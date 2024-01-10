extends Control


@onready var anim_player_1: AnimationPlayer = %AnimationPlayer1
@onready var anim_player_2: AnimationPlayer = %AnimationPlayer2

@onready var base_menu: Control = %BaseMenu

@onready var inventory_menu: Control = %Inventory
@onready var item_slots: Array = %InventoryGrid.get_children()
@onready var item_desc: Control = %ItemDescription
@onready var item_name_label: RichTextLabel = %ItemNameLabel
@onready var item_desc_label: RichTextLabel = %ItemDescriptionLabel

@onready var party_member_panel := preload("res://data/scenes/UI/party_member_1.tscn")
@onready var stats_menu: Control = %Stats
@onready var party_member_slots: Array = %StatsVbox.get_children()
@onready var party_member_stats: VBoxContainer = %MemberStatsVbox

@onready var stats_avatar: TextureRect = %StatsAvatar
@onready var stats_basic_info: RichTextLabel = %BasicInfoLabel
@onready var stats_hp: RichTextLabel = %HPLabel
@onready var stats_hp_bar: ProgressBar = %HPBar
@onready var stats_full: RichTextLabel = %FullStatsLabel

@onready var main_buttons: Array = %BaseMenuVbox.get_children()
# @onready var resume_button: Button = %ResumeButton
# @onready var inventory_button: Button = %InventoryButton
# @onready var stats_button: Button = %StatsButton
# @onready var option_button: Button = %OptionButton
# @onready var exit_button: Button = %ExitButton

var new_item: Item: set = set_new_item
var previous_item: Item: set = set_previous_item

var selected_item: ItemSlot
var previous_selected_item: ItemSlot

var current_party_member_selected: PartyMemberStats

var active_window: Node = null


func _ready() -> void:
	base_menu.hide()
	inventory_menu.hide()
	stats_menu.hide()
	item_desc.hide()
	party_member_stats.hide()

	for slot: ItemSlot in item_slots:
		slot.new_item_focused.connect(on_new_item_focused)
		slot.item_selected.connect(on_item_selected)


func _unhandled_input(event: InputEvent) -> void:
	if base_menu.visible and event.is_action_pressed("ui_cancel"):
		show_hide_main_ui(base_menu.visible)
	
	if !base_menu.visible and event.is_action_pressed("ui_cancel"):
		show_hide_main_ui(base_menu.visible)


func _on_resume_button_pressed() -> void:
	show_hide_main_ui(true)


func _on_inventory_button_pressed() -> void:
	active_window = inventory_menu
	anim_player_1.play("show_inventory_menu")
	item_slots[0].button.grab_focus()
	await anim_player_1.animation_finished


func _on_stats_button_pressed() -> void:
	active_window = stats_menu
	
	assign_party_members()
	
	anim_player_1.play("show_stats_menu")
	party_member_slots[0].button.grab_focus()
	await anim_player_1.animation_finished


func _on_option_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	accept_event()


func on_member_stats_button_focus_entered(member_stats: PartyMemberStats) -> void:
	current_party_member_selected = member_stats


func on_new_item_focused(item_slot: ItemSlot, item: Item) -> void:
	if anim_player_1.is_playing():
		await anim_player_1.animation_finished
	
	previous_selected_item = selected_item
	selected_item = item_slot

	previous_item = new_item
	new_item = item


func on_item_selected(_item: Item) -> void:
	active_window = stats_menu
	anim_player_1.play("show_stats_in_inventory")
	assign_party_members()
	previous_selected_item = selected_item
	party_member_slots[0].button.grab_focus()


func on_member_stats_pressed() -> void:
	## Called from on_item_selected().
	if selected_item:
		var item_effect: int = selected_item.item.use(current_party_member_selected.stats)

		match item_effect:
			0: # Effect Denied
				anim_player_1.play("shake_stats_in_inventory")
			1: # HEAL_HP
				pass
			2: # HEAL_MP
				pass
		
		GameManager.check_stats.emit()
			
		if !selected_item.item:
			current_party_member_selected.button.release_focus()
			anim_player_2.play("hide_item_description")
			await get_tree().create_timer(0.05).timeout
			show_hide_main_ui(true)
			return
	else:
		active_window = party_member_stats

		stats_avatar.texture = current_party_member_selected.sprite.texture
		stats_basic_info.text = current_party_member_selected.basic_info_text.text
		stats_hp.text = current_party_member_selected.health_label.text
		stats_hp_bar.value = current_party_member_selected.health_bar.value
		stats_hp_bar.max_value = current_party_member_selected.health_bar.max_value
		
		stats_full.text = "STRENGTH: %d\nAGILITY: %d\nINTELLIGENCE: %d" % \
		[current_party_member_selected.stats.strength,\
		current_party_member_selected.stats.agility,\
		current_party_member_selected.stats.intelligence]

		anim_player_1.play("show_member_stats")


func show_hide_main_ui(is_ui_visible: bool) -> void:
	if anim_player_1.is_playing(): return
	
	match active_window:
		null:
			if !is_ui_visible:
				anim_player_1.play("show_base_menu")
				active_window = base_menu
				await anim_player_1.animation_finished
		
		base_menu:
			if is_ui_visible:
				remove_button_focus()
				anim_player_1.play("hide_base_menu")
				active_window = null
				await anim_player_1.animation_finished
				GameManager.is_game_paused = false
				get_tree().paused = false
		
		inventory_menu:
			active_window = base_menu
			selected_item = null
			previous_selected_item = null
			current_party_member_selected = null
			anim_player_2.play("hide_item_description")
			anim_player_1.play("hide_inventory_menu")
		
		stats_menu:
			if inventory_menu.is_visible_in_tree():
				active_window = inventory_menu
				current_party_member_selected = null
				anim_player_1.play("hide_stats_in_inventory")
				await get_tree().create_timer(0.01).timeout
				selected_item.button.grab_focus()
			else:
				active_window = base_menu
				current_party_member_selected = null
				anim_player_1.play("hide_stats_menu")
		
		party_member_stats:
			active_window = stats_menu
			anim_player_1.play("show_stats_menu")
			party_member_slots[0].button.grab_focus()
	
	accept_event()
	return


func remove_button_focus() -> void:
	for button: Button in main_buttons:
		button.release_focus()


func main_buttons_focus_controller(state: bool) -> void:
	for button: Button in main_buttons:
		match state:
			true:
				button.disabled = false
				button.focus_mode = Control.FOCUS_ALL
			false:
				button.disabled = true
				button.focus_mode = Control.FOCUS_NONE


func inventory_buttons_focus_controller(state: bool) -> void:
	for item: ItemSlot in item_slots:
		match state:
			true:
				if item.enable:
					item.button.focus_mode = Control.FOCUS_ALL
			false:
				item.button.focus_mode = Control.FOCUS_NONE


func assign_party_members() -> void:
	var player_party: Array = GameManager.player_party

	if player_party.size() == party_member_slots.size():
		GameManager.check_stats.emit()
	else:
		for member: BasePlayer in %StatsVbox.get_children():
			%StatsVbox.remove_child(member)
			member.queue_free()
		
		for member: BasePlayer in player_party:
			var member_stats: PartyMemberStats = party_member_panel.instantiate()
			%StatsVbox.add_child(member_stats)

			member_stats.party_member_focus_entered.connect(on_member_stats_button_focus_entered)

			member_stats.stats = member.stats
			member_stats.assign_stats()
			member_stats.button.pressed.connect(on_member_stats_pressed)
			party_member_slots.append(member_stats)


func set_new_item(new: Item) -> void:
	if not new: return
	if selected_item == previous_selected_item:
		return
	
	new_item = new
	item_name_label.text = new_item.name
	item_desc_label.text = new_item.description
	anim_player_2.play("show_item_description")


func set_previous_item(previous: Item) -> void:
	if selected_item == previous_selected_item:
		return

	previous_item = previous
	anim_player_2.play("hide_item_description")
	await get_tree().create_timer(0.05).timeout
