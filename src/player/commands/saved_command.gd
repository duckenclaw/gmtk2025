class_name SavedCommand

var activation_time_sec: float
var command: Command

func _init(_activation_time_sec, _command: Command) -> void:
	activation_time_sec = _activation_time_sec
	command = _command
