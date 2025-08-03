extends Action

const BLACK_HOLE = preload("uid://c4xsb2ohggau7")

const DAMAGE_TIMEOUT: float = 2000 # msec

var last_damage_time: float = -100.0

@onready var preview_area: Area2D = $PreviewArea
@onready var preview_shape: CollisionShape2D = $PreviewArea/CollisionShape2D

@onready var preview_sprite: Sprite2D = $PreviewArea/Sprite2D
@onready var player: Player = $"../.."

func accept_command(command: Command):
	if command is CommandMouse:
		preview_area.visible = not is_reloading()
		preview_area.global_position = command.mouse_position
		preview_shape.shape.radius = player_config.black_hole_radius
		
	if command is CommandMouseReleased:
		if is_reloading():
			return
		last_damage_time = Time.get_ticks_msec()
		
		var black_hole: BlackHole = BLACK_HOLE.instantiate()
		black_hole.player_config = player_config
		player.get_parent().add_child(black_hole)
		
		black_hole.global_position = command.mouse_position

func is_reloading() -> bool:
	return Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT
