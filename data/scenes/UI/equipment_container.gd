extends PanelContainer


@onready var equipment_container: VBoxContainer = %VBoxContainer

@onready var v_scroll_bar: VScrollBar = %VScrollBar

var current_selection: int
var current_scroll: int

var panel_height := roundi(size.y)
var panel_height_gap: int
var tween: Tween

var is_ready := false


func _ready() -> void:
    v_scroll_bar.value = 0

    is_ready = true


func on_equipment_container_shown() -> void:
    for slot: EquipmentSlot in equipment_container.get_children():
        slot.button.focus_mode = FOCUS_ALL
        if slot.equipment_focused.is_connected(on_equipment_focused):
            continue

        slot.equipment_focused.connect(on_equipment_focused)
    
    v_scroll_bar.value = 0
    equipment_container.get_child(0).button.grab_focus()


func on_equipment_focused(slot: EquipmentSlot, item: Item) -> void:
    if slot.position.y + 32 > panel_height:
        var height_gap := roundi((slot.position.y + 32) - panel_height)

        if tween != null:
            print()
            prints("current_selection =", current_selection)
            prints("current_scroll =", current_scroll)
            print()
            equipment_container.position.y = current_selection
            v_scroll_bar.value = current_scroll

        current_selection = roundi(equipment_container.position.y) - height_gap
        current_scroll = roundi(v_scroll_bar.value) + height_gap

        panel_height += height_gap

        # equipment_container.position.y -= height_gap

        # v_scroll_bar.value += height_gap
        
        tween = create_tween()

        tween.tween_property(equipment_container, "position", Vector2(0, current_selection), 0.1)\
        .set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
        
        tween.parallel().tween_property(v_scroll_bar, "value", current_scroll, 0.1)\
        .set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

        prints("height_gap =", height_gap)
        prints("v_scroll_bar.value =", v_scroll_bar.value)
        prints("slot.position.y + 32 =", slot.position.y + 32)

        return
    
    if slot.position.y < (panel_height - 120):
        var height_gap := roundi(slot.position.y - (panel_height - 120))

        if tween != null:
            print()
            prints("current_selection =", current_selection)
            prints("current_scroll =", current_scroll)
            print()
            equipment_container.position.y = current_selection
            v_scroll_bar.value = current_scroll

        current_selection = roundi(equipment_container.position.y) - height_gap
        current_scroll = roundi(v_scroll_bar.value) + height_gap

        panel_height += height_gap

        # equipment_container.position.y -= height_gap

        # v_scroll_bar.value += height_gap
        
        tween = create_tween()

        tween.tween_property(equipment_container, "position", Vector2(0, current_selection), 0.1)\
        .set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
        
        tween.parallel().tween_property(v_scroll_bar, "value", current_scroll, 0.1)\
        .set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

        prints("v_scroll_bar.value =", v_scroll_bar.value)
        prints("slot.position.y - 32 =", slot.position.y - 32)

        return


func _on_v_box_container_resized() -> void:
    if is_ready == false:
        await ready
    
    if equipment_container.size == size:
        v_scroll_bar.hide()
        return
    
    v_scroll_bar.show()

    panel_height_gap = roundi(equipment_container.size.y - size.y)

    v_scroll_bar.max_value = panel_height_gap


func tween_focus() -> void:
    pass