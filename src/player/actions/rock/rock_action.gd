extends Action
class_name RockAction

const ROCK = preload("res://src/player/actions/rock/rock.tscn")

const DAMAGE_TIMEOUT: float = 1200 # msec

var last_damage_time: float = -100.0

@onready var player: Player = $"../.."
@onready var preview_area: PreviewArea = $PreviewArea

func accept_command(command: Command):
	if command is CommandMouse:
		preview_area.visible = not is_reloading()
		preview_area.global_position = command.mouse_position
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
		rock.global_position = global_position
		rock.start()

func is_reloading() -> bool:
	return Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT
