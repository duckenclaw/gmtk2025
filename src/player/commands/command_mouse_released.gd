extends Command
class_name CommandMouseReleased

var direction: Vector2
var mouse_position: Vector2

func _init(_direction: Vector2, _mouse_position: Vector2) -> void:
	direction = _direction
	mouse_position = _mouse_position
