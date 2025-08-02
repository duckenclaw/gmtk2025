extends Action

const DAMAGE_TIMEOUT: float = -1 # msec
const LASER_LENGTH: float = 2000.0
const LASER_DAMAGE: float = 20.0
const LASER_IMPULSE: float = 5.0

var last_damage_time = 0.0

@onready var laser_raycast = $LaserRaycast
@onready var player: Player = $"../.."

func accept_command(command: Command):
	if command is CommandMouseReleased:
		if is_reloading():
			return
		
		laser_raycast.enabled = true
		
		laser_raycast.target_position = command.mouse_position
		var enemy = laser_raycast.get_collider()
		if enemy:
			print(enemy)
			if enemy.is_in_group("enemy"):
				enemy.take_damage(LASER_DAMAGE)
				enemy.take_impulse(LASER_IMPULSE * global_position.direction_to(enemy.global_position))
		laser_raycast.enabled = false

func is_reloading() -> bool:
	return Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT
