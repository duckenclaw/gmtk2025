class_name Record

var id: String
var original_history: Array[SavedCommand]
var history: Array[SavedCommand]
var position_history: PackedVector2Array

func _init(_id, _history, _position_history) -> void:
	id = "Record " + str(id)
	original_history = _history
	history = _history
	position_history = _position_history

func reset():
	history = original_history.duplicate()
