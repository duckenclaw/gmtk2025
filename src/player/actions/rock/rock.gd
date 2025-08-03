extends Area2D
class_name Rock

const ROCK_SPEED = 600

var player_config: PlayerConfig
var target_position: Vector2
var direction: Vector2
var has_exploded: bool = false

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta):
	if has_exploded:
		return
		
	# Move toward target
	global_position += direction * ROCK_SPEED * delta
	
	# Check if we've reached the target
	var distance_to_target = global_position.distance_to(target_position)
	print("current cords: " + str(global_position) + "\ntarget cords: " + str(target_position))
	if distance_to_target <= 50.0:
		print("distance to target less than 10")
		explode()

func explode():
	if has_exploded:
		return
	
	has_exploded = true
	
	# Stop at target position
	direction = Vector2(0, 0)
	
	# Scale up sprite for explosion effect
	if has_node("Sprite2D"):
		var tween = create_tween()
		tween.tween_property($Sprite2D, "scale", Vector2(2.0, 2.0), 0.2)
		tween.tween_property($Sprite2D, "modulate:a", 0.0, 0.3)
	
	# Deal damage to all enemies in AoE
	await get_tree().process_frame # Wait one frame for collision to update
	for area in get_overlapping_areas():
		if area.is_in_group("enemy"):
			area.take_damage(player_config.rock_damage)
			area.take_impulse(direction * player_config.rock_impulse)
	
	 # Create explosion particles if available
	if has_node("CPUParticles2D"):
		$CPUParticles2D.emitting = true
	# Clean up after explosion
	await WaitUtil.wait(0.5)
	queue_free()
