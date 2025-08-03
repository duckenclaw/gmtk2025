extends Action
class_name RockAction

const ROCK = preload("res://src/player/actions/rock/rock.tscn")

const DAMAGE_TIMEOUT: float = 1200 # msec

var last_damage_time: float = -100.0

@onready var player: Player = $"../.."

func accept_command(command: Command):
	if command is CommandMouseReleased:
		var direction = global_position.direction_to(command.mouse_position)
		if is_reloading():
			return
		last_damage_time = Time.get_ticks_msec()
		
		var rock: Rock = ROCK.instantiate()
		rock.player_config = player_config
		rock.direction = direction
		rock.target_position = command.mouse_position
		player.get_parent().add_child(rock)
		
		rock.global_position = player.global_position

func is_reloading() -> bool:
	return Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT
