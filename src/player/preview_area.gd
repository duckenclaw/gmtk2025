extends Area2D
class_name PreviewArea

var radius: float

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color(0, 0, 0, 0.2), true, -1, true)
