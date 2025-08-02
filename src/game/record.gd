class_name Record

var id: String
var original_history: Array[SavedCommand]
var history: Array[SavedCommand]
var position_history: PackedVector2Array
var player_config: PlayerConfig
var selected_action_index: int
var color: Color

func _init(
		_id, 
		_history, 
		_position_history,
		_player_config, 
		_selected_action_index,
		_color
	) -> void:
	
	id = "Record " + str(_id)
	original_history = _history
	history = _history
	position_history = _position_history
	player_config = _player_config
	selected_action_index = _selected_action_index
	color = _color
	

func reset():
	history = original_history.duplicate()
