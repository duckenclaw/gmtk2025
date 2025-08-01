extends Command
class_name CommandMove

var direction: Vector2
var delta: float

func _init(_direction, _delta) -> void:
	direction = _direction
	delta = _delta
