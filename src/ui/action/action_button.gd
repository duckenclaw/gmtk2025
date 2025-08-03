extends PanelContainer
class_name ActionButton

@export var texture: CompressedTexture2D

var action_index: int
var is_available: bool
var is_pending: bool
var is_active: bool

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var label: Label = $MarginContainer/Label


func _ready() -> void:
	texture_rect.texture = texture

func _process(_delta: float) -> void:
	label.text = str(action_index)
	
	if not is_available:
		texture_rect.modulate = Color.BLACK
	else:
		if is_active:
			texture_rect.modulate = Color.WHITE
		else:
			texture_rect.modulate = Color.DIM_GRAY
