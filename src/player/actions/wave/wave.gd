extends Area2D
class_name Wave

const WAVE_SPEED = 400
const WAVE_IMPULSE = 1.5
const WAVE_LIFETIME = 3.0 # seconds

var player_config: PlayerConfig
var target_position: Vector2
var direction: Vector2
var damaged_enemies: Array[Area2D] = []

func _ready() -> void:
	# Calculate direction from spawn position to target
	direction = global_position.direction_to(target_position)
	
	# Set up collision shape based on player config
	$CollisionShape2D.shape.size = Vector2(player_config.wave_width, player_config.wave_width*5)
	
	# Scale sprite if it exists
	if has_node("Sprite2D"):
		$Sprite2D.scale.x = player_config.wave_width/100.0
		$Sprite2D.scale.y = player_config.wave_width/100.0
	
	# Auto-destroy after lifetime
	await WaitUtil.wait(WAVE_LIFETIME)
	queue_free()

func _physics_process(delta):
	# Move the wave toward the target direction
	global_position += direction * WAVE_SPEED * delta
	
	# Check for overlapping enemies
	for area in get_overlapping_areas():
		if area.is_in_group("enemy") and not area in damaged_enemies:
			# Deal damage once per enemy
			area.take_damage(player_config.wave_damage)
			damaged_enemies.append(area)
			
			# Apply impulse in the direction the wave is traveling
			var impulse = direction * WAVE_IMPULSE
			area.take_impulse(impulse)
