class_name InventoryMenu
extends Control


@onready var item_slots: Array = %InventoryGrid.get_children()
@onready var item_desc: Control = %ItemDescription
@onready var item_name_label: RichTextLabel = %ItemNameLabel
@onready var item_desc_label: RichTextLabel = %ItemDescriptionLabel

var main_ui: MainUI

var new_item: Item: set = set_new_item
var previous_item: Item: set = set_previous_item

var selected_slot: ItemSlot
var previous_selected_slot: ItemSlot


func _ready() -> void:
    item_desc.hide()

    for slot: ItemSlot in item_slots:
        slot.new_item_focused.connect(on_new_item_focused)
        slot.item_selected.connect(on_item_selected)

    if not GameManager.is_game_ready:
        await GameManager.game_ready
    
    main_ui = get_parent()


func inventory_buttons_focus_controller(state: bool) -> void:
    for item: ItemSlot in item_slots:
        match state:
            true:
                if item.enable:
                    item.button.focus_mode = Control.FOCUS_ALL
            false:
                item.button.focus_mode = Control.FOCUS_NONE


func on_new_item_focused(item_slot: ItemSlot, item: Item) -> void:
    if main_ui.anim_player_1.is_playing():
        await main_ui.anim_player_1.animation_finished
    
    previous_selected_slot = selected_slot
    selected_slot = item_slot

    previous_item = new_item
    new_item = item


func on_item_selected(_item: Item) -> void:
    main_ui.active_window = main_ui.stats_menu
    main_ui.anim_player_1.play("show_stats_in_inventory")
    main_ui.stats_menu.assign_party_members()
    
    previous_selected_slot = selected_slot
    main_ui.stats_menu.party_member_slots[0].button.grab_focus()


func set_new_item(new: Item) -> void:
    if not new: return
    if selected_slot == previous_selected_slot:
        return
    
    new_item = new
    item_name_label.text = new_item.name
    item_desc_label.text = new_item.description
    main_ui.anim_player_2.play("show_item_description")


func set_previous_item(previous: Item) -> void:
    if selected_slot == previous_selected_slot:
        return

    previous_item = previous
    main_ui.anim_player_2.play("hide_item_description")
    await get_tree().create_timer(0.05).timeout