extends Action

const BLACK_HOLE = preload("uid://c4xsb2ohggau7")

const DAMAGE_TIMEOUT: float = 2000 # msec

var last_damage_time = 0.0

@export var radius = 200

@onready var preview_area: Area2D = $PreviewArea
@onready var preview_sprite: Sprite2D = $PreviewArea/Sprite2D
@onready var player: Player = $"../.."

func accept_command(command: Command):
	print(is_reloading())
	if command is CommandMouse:
		preview_area.visible = not is_reloading()
		preview_area.global_position = command.mouse_position
	if command is CommandMouseReleased:
		if is_reloading():
			return
		
		var black_hole = BLACK_HOLE.instantiate()
		black_hole.black_hole_radius = radius
		player.get_parent().add_child(black_hole)
		
		black_hole.global_position = command.mouse_position

func is_reloading() -> bool:
	return Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT
