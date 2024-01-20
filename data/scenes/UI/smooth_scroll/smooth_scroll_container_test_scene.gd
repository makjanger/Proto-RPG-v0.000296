extends PanelContainer


@onready var rich_text_label: RichTextLabel = %RichTextLabel1
# @onready var smooth_scroller: SmoothScrollContainer = %SmoothScrollContainer


func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	# rich_text_label.grab_focus()

func _physics_process(_delta: float) -> void:
	# print(smooth_scroller.get_v_scroll())
	pass
