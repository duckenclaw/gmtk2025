extends Area2D
class_name Rock

const ROCK_SPEED: float = 600.0

var player_config: PlayerConfig
var target_position: Vector2
var direction: Vector2
var has_exploded: bool = false

var total_time: float
var time: float
var start_position: Vector2
var total_distance: float

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func start():
	visible = false
	start_position = global_position
	total_distance = start_position.distance_to(target_position)
	total_time = total_distance / ROCK_SPEED
	rotation = direction.angle()

func _physics_process(delta):
	if has_exploded:
		return

	visible = true

	time += delta
	var t = clamp(time / total_time, 0.0, 1.0)
	var max_arc_height = total_distance * 0.5

	global_position = start_position.lerp(target_position, t)
	var arc = -4.0 * max_arc_height * (t - 0.5) * (t - 0.5) + max_arc_height
	global_position.y -= arc

	if global_position.distance_to(target_position) <= 50.0:
		explode()

func explode():
	if has_exploded:
		return
	
	queue_redraw()
	
	has_exploded = true
	direction = Vector2.ZERO

	if has_node("Sprite2D"):
		var tween = create_tween()
		tween.tween_property($Sprite2D, "scale", Vector2(0.0, 0.0), 0.2)
		tween.tween_property($Sprite2D, "modulate:a", 0.0, 0.3)

	await get_tree().process_frame
	Sound.play_rock()
	for area in get_overlapping_areas():
		if area.is_in_group("enemy"):
			area.take_damage(player_config.rock_damage)
			area.take_impulse(global_position.direction_to(area.global_position) * player_config.rock_impulse)

	if has_node("CPUParticles2D"):
		$CPUParticles2D.emitting = true

	await WaitUtil.wait(0.5)
	queue_free()

func _draw() -> void:
	if has_exploded:
		draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color(0, 0, 0, 0.2), true, -1, true)
