class_name Item
extends Resource


enum ItemType { CONSUMABLE, EQUIPPABLE }


@export var texture: Texture
@export var item_name: String
@export_multiline var item_desc: String
@export var item_type: ItemType = ItemType.CONSUMABLE
