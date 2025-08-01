extends Command
class_name CommandMouse

var direction: Vector2
var mouse_position: Vector2
var is_pressed: bool

func _init(_direction: Vector2, _mouse_position: Vector2, _is_pressed: bool) -> void:
	direction = _direction
	mouse_position = _mouse_position
	is_pressed = _is_pressed
