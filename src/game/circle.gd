extends Node2D
class_name Circle

func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var value = 1.0 - State.loop_value
	var a = State.loop_value / 3.0
	var r = a
	draw_circle(Vector2.ZERO, value * 1000, Color(1, a, a, a), false, a * 20, true)
