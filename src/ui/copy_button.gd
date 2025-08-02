extends PanelContainer
class_name CopyButton

var record: Record
var copy: Player

@onready var player: TextureRect = $MarginContainer/Container/Player
@onready var left_hand: TextureRect = $MarginContainer/Container/LeftHand
@onready var right_hand: TextureRect = $MarginContainer/Container/RightHand


func _ready() -> void:
	if record != null:
		setup_record()
	else:
		setup_empty()

func setup_record():
	set_color(record.color)

func setup_empty():
	set_color(Color.DIM_GRAY)

func set_color(color):
	player.material.set_shader_parameter("modulate_color", color)
	left_hand.material.set_shader_parameter("modulate_color", color)
	right_hand.material.set_shader_parameter("modulate_color", color)

func _on_click_listener_mouse_pressed() -> void:
	pass # Replace with function body.
