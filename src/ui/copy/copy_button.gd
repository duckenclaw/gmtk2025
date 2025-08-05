extends MarginContainer
class_name CopyButton

const AIR_BIG = preload("uid://crsjay82i3ldi")
const FIRE_BIG = preload("uid://chby0tlyn6ij0")
const ROCK_BIG = preload("uid://c1x4td4yx8npc")
const WATER_BIG = preload("uid://dhx4fp48nt5ty")
const DARK_BIG = preload("uid://xwiulgb2olth")

signal clicked

var record: Record
var copy: Player

@onready var player: TextureRect = $PanelContainer/MarginContainer/Container/Player
@onready var left_hand: TextureRect = $PanelContainer/MarginContainer/Container/LeftHand
@onready var right_hand: TextureRect = $PanelContainer/MarginContainer/Container/RightHand
@onready var action_rect: TextureRect = $PanelContainer/MarginContainer/Container/ActionRect
@onready var loader: Sprite2D = $PanelContainer/MarginContainer/Container/Loader

func _ready() -> void:
	if record != null:
		setup_record()
	else:
		setup_empty()
	loader.rotation = Time.get_ticks_msec() / 1000.0

func setup_record():
	set_color(record.color)
	action_rect.visible = true
	action_rect.texture = get_action_texture()
	loader.visible = copy == null
		

func setup_empty():
	set_color(Color.DIM_GRAY)
	action_rect.visible = false
	loader.visible = false

func set_color(color):
	player.material.set_shader_parameter("modulate_color", color)
	left_hand.material.set_shader_parameter("modulate_color", color)
	right_hand.material.set_shader_parameter("modulate_color", color)

func _on_click_listener_mouse_pressed() -> void:
	clicked.emit()

func get_action_texture() -> CompressedTexture2D:
	match record.selected_action_index:
		0:
			return FIRE_BIG
		1:
			return DARK_BIG
		2:
			return AIR_BIG
		3:
			return WATER_BIG
		4:
			return ROCK_BIG
	return null
