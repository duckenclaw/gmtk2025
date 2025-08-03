extends Action
class_name WaveAction

const WAVE = preload("res://src/player/actions/wave/wave.tscn")

const DAMAGE_TIMEOUT: float = 800 # msec

var last_damage_time: float = -100.0

@export var range = 300

@onready var player: Player = $"../.."

func accept_command(command: Command):
	if command is CommandMouse:
		# Position preview halfway between player and mouse for better visualization
		var direction = global_position.direction_to(command.mouse_position)
		
	if command is CommandMouseReleased:
		if is_reloading():
			return
		last_damage_time = Time.get_ticks_msec()
		
		var wave: Wave = WAVE.instantiate()
		wave.player_config = player_config
		wave.direction = command.direction
		player.get_parent().get_parent().add_child(wave)
		wave.global_position = player.global_position

func is_reloading() -> bool:
	return Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT
