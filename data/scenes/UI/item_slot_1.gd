@tool
class_name ItemSlot
extends PanelContainer


signal new_item_focused(slot: ItemSlot, new_item: Item)
signal item_selected(item: Item)


@export var disable_tex: Texture
@onready var sprite := %Sprite2D
@onready var button := %ItemButton
@onready var amount_label := %AmountLabel

@export var enable: bool = true:
    set(new_state):
        enable = new_state
        if not is_ready: await ready

        if enable:
            texture = null
            button.focus_mode = Control.FOCUS_ALL
        else:
            texture = disable_tex
            button.focus_mode = Control.FOCUS_NONE


@export var item: Item:
    set(new_item):
        item = new_item
        if item:
            texture = item.texture
        else:
            texture = null


var texture: Texture:
    set(new_texture):
        if not is_ready: await ready
        
        if new_texture == null:
            texture = null
            sprite.texture = texture
            return
        
        texture = new_texture
        sprite.texture = texture

var is_ready: bool = false


func _ready() -> void:
    amount_label.hide()
    size = Vector2(40, 40)

    if item:
        item.property_changed.connect(item_property_changed)
        set_item_amount()
        set_item_stackable()
    
    if button:
        button.button_down.connect(on_button_down)
        button.focus_entered.connect(on_button_focus_entered)
        button.focus_exited.connect(on_button_focus_exited)

    is_ready = true


func item_property_changed(property_name: String) -> void:
    match property_name:
        "item_amount":
            set_item_amount()
        "item_stackable":
            set_item_stackable()
        _:
            printerr("PROPERTY UNKNOWN!!")


func on_button_down() -> void:
    if not item: 
        printerr("NO ITEM IN SLOT!!")
        return
    
    item_selected.emit(item)


func on_button_focus_entered() -> void:
    new_item_focused.emit(self, item)


func on_button_focus_exited() -> void:
    pass


func set_item_amount() -> void:
    print("{SET ITEM: ", item.name, "} {AMOUNT: ", item.amount, "}")
    if item.amount <= 0:
        item = null
        amount_label.hide()
        amount_label.text = "x0"
        return

    amount_label.text = "x%d" % [item.amount]


func set_item_stackable() -> void:
    print("{SET ITEM: ", item.name, "} {STACKABLE: ", item.stackable, "}")
    if item.stackable:
        amount_label.show()
    else:
        amount_label.hide()
