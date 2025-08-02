class_name Drag

const COMMON_IMPULSE_MULTIPLIER = 1.0

const COMMON_DRAG_MULTIPLIER: float = 0.95
const COMMON_DRAG: float = 2.5
const MIN_VELOCITY: float = COMMON_DRAG + 2.0

static func drag(velocity: Vector2) -> Vector2:
	velocity = velocity * COMMON_DRAG_MULTIPLIER
	velocity = velocity - velocity.normalized() * COMMON_DRAG
	if velocity.length() < MIN_VELOCITY:
		velocity = Vector2.ZERO
	
	return velocity
