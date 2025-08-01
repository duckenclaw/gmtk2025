extends Area2D
class_name BlackHole


func _ready() -> void:
	
	await WaitUtil.wait(5.0)
	queue_free()
