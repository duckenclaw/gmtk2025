extends Action

const DAMAGE_TIMEOUT: float = 1000 # msec

var last_damage_time = 0.0
var is_laser_active: bool = false
var laser_tween: Tween
var original_laser_width: float = 8.0

@onready var laser_area = $LaserArea
@onready var laser_collider = $LaserArea/CollisionShape2D
@onready var casting_particles = $LaserArea/CastingParticles
@onready var collision_particles = $LaserArea/CollisionParticles
@onready var laser_line = $LaserArea/Line2D
@onready var player: Player = $"../.."

var target_group: String = "enemy"
var targets_in_area: Array

func accept_command(command: Command):
	if command is CommandMouse:
		laser_area.rotation = command.direction.angle()
		
		if command.is_pressed and not is_laser_active:
			start_laser()
		elif not command.is_pressed and is_laser_active:
			stop_laser()
		
		# Deal continuous damage while laser is active
		if is_laser_active:
			if Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT: return
			for enemy in targets_in_area:
				enemy.take_damage(player_config.laser_damage * player_config.damage_mult)

func is_reloading() -> bool:
	return Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT

func start_laser():
	Sound.play_laser()
	if is_laser_active:
		return
		
	is_laser_active = true
	
	# Kill existing tween if running
	if laser_tween:
		laser_tween.kill()
	
	# Start casting particles first
	casting_particles.emitting = true
	
	# Ensure laser line is in correct initial state
	laser_line.visible = true
	laser_line.modulate.a = 0.0
	
	# Reset width to 0 for animation
	original_laser_width = player_config.laser_width
	laser_line.width = 0
	
	# Create main laser animation tween
	laser_tween = create_tween()
	laser_tween.set_parallel(true)  # Allow multiple animations
	
	# Animate laser line appearance
	laser_tween.tween_property(laser_line, "modulate:a", 1.0, 0.15)
	
	# Scale up the laser line width
	laser_tween.tween_property(laser_line, "width", original_laser_width, 0.2)
	
	# Enable collision after brief delay
	laser_tween.tween_callback(enable_collision).set_delay(0.1)
	
	# Start collision particles for any enemies already in area
	laser_tween.tween_callback(func(): collision_particles.emitting = true).set_delay(0.2)

func stop_laser():
	if not is_laser_active:
		return
		
	is_laser_active = false
	
	# Kill existing tween
	if laser_tween:
		laser_tween.kill()
	
	casting_particles.emitting = false
	
	# Create fade out tween
	laser_tween = create_tween()
	laser_tween.set_parallel(true)
	
	# Fade out laser line
	laser_tween.tween_property(laser_line, "modulate:a", 0.0, 0.1)
	laser_tween.tween_property(laser_line, "width", 0, 0.1)
	
	collision_particles.emitting = false
	
	# Disable collision
	laser_collider.visible = false
	
	# Hide line AFTER fade completes (this was the missing delay!)
	laser_tween.tween_callback(func(): laser_line.visible = false).set_delay(0.1)

func enable_collision():
	laser_collider.visible = true

func _ready():
	# Store original width from editor settings
	if laser_line.width > 0:
		original_laser_width = laser_line.width
	else:
		original_laser_width = 8.0  # Default fallback width
	
	# Initialize visual elements as hidden
	laser_line.visible = false
	laser_collider.visible = false
	laser_line.modulate.a = 0.0
	
	# Make sure particles aren't emitting at start
	casting_particles.emitting = false
	collision_particles.emitting = false

func _on_area_entered(area):
	if area.is_in_group(target_group):
		targets_in_area.append(area)
		# Start collision particles when enemies enter
		if is_laser_active:
			collision_particles.emitting = true

func _on_area_exited(area):
	targets_in_area.erase(area)
	# Stop collision particles if no enemies left
	if targets_in_area.is_empty():
		collision_particles.emitting = false
