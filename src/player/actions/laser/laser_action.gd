extends Action

const DAMAGE_TIMEOUT: float = -1 # msec
const LASER_DAMAGE: float = 20.0
const LASER_IMPULSE: float = 5.0

var last_damage_time = 0.0

@onready var laser_area = $LaserArea
@onready var laser_collider = $LaserArea/CollisionShape2D
@onready var player: Player = $"../.."


var target_group: String = "enemy"
var targets_in_area: Array

func accept_command(command: Command):
	if command is CommandMouse:
		laser_area.rotation = command.direction.angle()
		laser_collider.visible = command.is_pressed
		if Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT: return
		
		if command.is_pressed:
			print(targets_in_area)
			for enemy in targets_in_area:
				enemy.take_damage(LASER_DAMAGE)
				enemy.take_impulse(LASER_IMPULSE * global_position.direction_to(enemy.global_position))

func is_reloading() -> bool:
	return Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT


func _on_area_entered(area):
	if area.is_in_group(target_group):
		targets_in_area.append(area)


func _on_area_exited(area):
	targets_in_area.erase(area)
