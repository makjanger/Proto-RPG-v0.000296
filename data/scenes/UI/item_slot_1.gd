@tool
class_name ItemSlot
extends PanelContainer


@export var disable_tex: Texture
@onready var sprite := %Sprite2D
@onready var button := %ItemButton

@export var disable: bool = false:
    set(new_state):
        disable = new_state
        await ready

        if disable:
            texture = disable_tex
            button.focus_mode = Control.FOCUS_NONE
        else:
            texture = null
            button.focus_mode = Control.FOCUS_ALL


var item: Item:
    set(new_item):
        item = new_item
        texture = item.texture


var texture: Texture:
    set(new_texture):
        if new_texture == null:
            texture = null
            return
        
        texture = new_texture
        sprite.texture = texture


func _ready() -> void:
    pass