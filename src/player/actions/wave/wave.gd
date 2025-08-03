extends Area2D
class_name Wave

const WAVE_SPEED = 400
const WAVE_IMPULSE = 1.5

var player_config: PlayerConfig
var direction: Vector2
var damaged_enemies: Array[Area2D] = []

func _ready() -> void:
	rotation = direction.angle()
	
	# Set up collision shape based on player config
	$CollisionShape2D.shape.size = Vector2(player_config.wave_width / 5.0, player_config.wave_width)
	$CPUParticles2D.emission_rect_extents = Vector2(player_config.wave_width / 10.0, player_config.wave_width / 2.0)
	
	# Auto-destroy after lifetime
	await WaitUtil.wait(player_config.wave_lifetime)
	$CollisionShape2D.queue_free()
	$CPUParticles2D.emitting = false
	await WaitUtil.wait(0.7)
	queue_free()

func _physics_process(delta):
	# Move the wave toward the target direction
	global_position += direction * WAVE_SPEED * delta
	
	# Check for overlapping enemies
	for area in get_overlapping_areas():
		if area.is_in_group("enemy"):
			area.take_impulse(direction * 5.0)
			if not area in damaged_enemies:
				area.take_damage(player_config.wave_damage)
				damaged_enemies.append(area)
			
			# Apply impulse in the direction the wave is traveling
			var impulse = direction * WAVE_IMPULSE
			area.take_impulse(impulse)
