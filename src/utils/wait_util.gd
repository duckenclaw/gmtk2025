extends Node
#class_name WaitUtil


func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
