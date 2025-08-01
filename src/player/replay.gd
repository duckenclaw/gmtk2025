extends Node
class_name Replay

var history: Array[SavedCommand]

var is_replaying: bool = false
var replay_porgress: float = 0.0


func _process(delta: float) -> void:
	
	if is_replaying:
		pass
