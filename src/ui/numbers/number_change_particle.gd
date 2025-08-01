extends CenterContainer
class_name NumberChangeParticle

signal was_stashed

const UP_SPEED: float = 60.0
const MAX_TIME: float = 2.0
const RANDOM_OFFSET: Vector2 = Vector2(80, 30)

var stashed: bool = false
var cumulative_delta: float = 0.0


func setup(g_pos: Vector2, res: ParticlePool.ParticleType, amount: float):
	$Label.text = str(int(amount))
	
	global_position = g_pos
	position.x -= 100
	position += Random.point_within_box(RANDOM_OFFSET)
	
	modulate.a = 1.0
	
	set_process(true)
	visible = true

func _process(delta: float) -> void:
	
	position.y -= delta * UP_SPEED
	modulate.a = 1 - cumulative_delta/MAX_TIME
	
	cumulative_delta += delta
	
	if cumulative_delta > MAX_TIME:
		stash()

func stash():
	set_process(false)
	visible = false
	stashed = true
	cumulative_delta = 0.0
	was_stashed.emit()
