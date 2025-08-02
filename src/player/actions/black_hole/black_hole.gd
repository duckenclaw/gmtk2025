extends Area2D
class_name BlackHole

const BLACK_HOLE_IMPULSE = 1.0
const BLACK_HOLE_DAMAGE = 10.0

var black_hole_radius = 200

func _ready() -> void:
	$CollisionShape2D.shape.radius = black_hole_radius
	
	await WaitUtil.wait(5.0)
	queue_free()
	
func _physics_process(delta):
	for area in get_overlapping_areas():
		if area.is_in_group("enemy"):
			area.take_impulse(BLACK_HOLE_IMPULSE * area.global_position.direction_to(global_position))
			#area.take_damage(BLACK_HOLE_DAMAGE)
