extends Action
class_name FireAction

const FIRE_IMPULSE = 1.0
const DAMAGE_TIMEOUT: float = 150 # msec

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var cpu_particles: CPUParticles2D = $Area2D/CPUParticles2D


var target_group: String = "enemy"
var targets_in_area: Array
var is_active: bool = false

var last_damage_time: float = 0.0


func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)

func accept_command(command: Command):
	if command is CommandMouse:
		area_2d.rotation = command.direction.angle()
		
		if Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT: 
			return
		
		if command.is_pressed and not is_active:
			start_fire()
			for enemy in targets_in_area:
				enemy.take_damage(player_config.fire_damage * player_config.damage_mult)
				enemy.take_impulse(FIRE_IMPULSE * global_position.direction_to(enemy.global_position))
		else: 
			stop_fire()

func start_fire():
	if not is_active:
		Sound.play_fire()
	is_active = true
	collision_shape_2d.visible = true
	cpu_particles.emitting = true
	
func stop_fire():
	is_active = false
	collision_shape_2d.visible = false
	cpu_particles.emitting = false

func _on_area_entered(area):
	if area.is_in_group(target_group):
		targets_in_area.append(area)

func _on_area_exited(area):
	targets_in_area.erase(area)
