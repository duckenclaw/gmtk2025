extends Node2D
class_name Action

var available: bool = false
var active: bool = false
var player_config: PlayerConfig

func accept_command(command: Command):
	pass

static func get_action_enabled(index: int) -> bool:
	match index:
		0:
			return State.fire_available
		1:
			return State.black_hole_available
		2: 
			return State.laser_available
		3: 
			return State.wave_available
		4:
			return State.rock_available
	return false
