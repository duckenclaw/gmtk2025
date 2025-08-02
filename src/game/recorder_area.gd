extends Area2D
class_name RecorderArea

const PLAYER = preload("uid://cni2a6p1fkqef")

@onready var lines_node: Node2D = $Lines
@onready var game_map: GameMap = $"../GameMap"



var lines: Dictionary # id to Line2D

var tween: Tween


func _ready() -> void:
	State.loop_restarted.connect(restart_copies)
	State.loop_progress.connect(on_loop_progress)

func restart_copies():
	for copy in State.copies.values():
		copy.queue_free()
	State.copies.clear()
	
	for record in State.records:
		record.reset()
		
		var copy = PLAYER.instantiate()
		copy.is_copy = true
		copy.player_config = record.player_config
		copy.selected_action_index = record.selected_action_index
		
		State.copies[record.id] = copy
		game_map.add_child(copy)
		
		remove_path(record.id)
		display_path(record.position_history, Color.BLUE, record.id)
		print("Created player copy: " + record.id + " action " + str(record.selected_action_index))

func on_loop_progress(_value: float, seconds: float):
	for id in State.copies.keys(): 
		var record = State.get_record(id)
		var copy = State.copies[id]
		
		var iteration := 0
		while true:
			iteration += 1
			if iteration > 100: break
			
			if record.history.is_empty(): break
			
			var saved_command: SavedCommand = record.history.front()
			#print(str(saved_command.activation_time_sec))
			if saved_command.activation_time_sec > seconds: break
			
			record.history.pop_front()
			var command: Command = saved_command.command
			copy.accept_command(command)
		
		


func display_path(path: PackedVector2Array, color: Color, id: String):
	var line = get_or_create_line(path, color, id)
	line.points = path

func get_or_create_line(path: PackedVector2Array, color: Color, id: String):
	if lines.has(id) and is_instance_valid(lines[id]):
		return lines[id]
	
	var line: Line2D = Line2D.new()
	line.default_color = color
	line.name = id
	lines_node.add_child(line)
	lines[id] = line
	return line

func remove_path(id: String):
	if lines.has(id) and is_instance_valid(lines[id]):
		lines[id].queue_free()
		lines.erase(id)

func save_recording(player: Player, id: int):
	print("Added new recording")
	var copied_config: PlayerConfig = player.player_config.duplicate()
	copied_config.is_copy = true
	var record = Record.new(
		id, 
		player.history, 
		player.position_history,
		copied_config,
		player.selected_action_index,
		get_record_color(id)
		)
	State.records.append(record)

func get_record_color(index: int) -> Color:
	return Random.color(0.5, 1.0)
