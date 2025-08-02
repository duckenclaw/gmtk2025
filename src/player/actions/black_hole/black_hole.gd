extends Area2D
class_name BlackHole

const BLACK_HOLE_IMPULSE = 2.0

var player_config: PlayerConfig

func _ready() -> void:
	$CollisionShape2D.shape.radius = player_config.black_hole_radius
	
	await WaitUtil.wait(0.1)
	for area in get_overlapping_areas():
		if area.is_in_group("enemy"):
			area.take_damage(player_config.black_hole_damage)
	
	await WaitUtil.wait(5.0)
	queue_free()

func _physics_process(delta):
	for area in get_overlapping_areas():
		if area.is_in_group("enemy"):
			var distance = area.global_position.distance_to(global_position)
			if distance <= 5.0:
				continue
			var impulse = BLACK_HOLE_IMPULSE * area.global_position.direction_to(global_position)
			area.take_impulse(impulse)
