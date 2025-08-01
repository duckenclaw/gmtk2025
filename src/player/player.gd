extends Node2D
class_name Player

const MOVE_SPEED = 400.0

var is_copy: bool = false

signal player_died
signal player_health_changed(health: float)

var history: Array[SavedCommand]
var is_recording: bool = false
var start_of_recording: float = 0.0

var actions: Array[Action]
var current_action: Action

var health := State.player_max_health

@onready var actions_node: Node2D = $Actions


func _ready() -> void:
	actions.append_array(actions_node.get_children())
	current_action = $Actions/NoneAction
	current_action = actions[1]



func _physics_process(delta: float) -> void:
	if is_copy: return
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction = direction.normalized()
	accept_command(CommandMove.new(direction, delta))
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	var mouse_direction: Vector2 = (mouse_pos - global_position).normalized()
	var command_mouse := CommandMouse.new(mouse_direction, mouse_pos, Input.is_action_pressed("mouse_click"))
	accept_command(command_mouse)
	
	if Input.is_action_just_released("mouse_click"):
		var command_click := CommandMouseReleased.new(mouse_direction, mouse_pos)
		accept_command(command_click)


func accept_command(command: Command): 
	if is_recording:
		var since_start = get_ticks_sec() - start_of_recording
		history.append(SavedCommand.new(since_start, command))
	
	current_action.accept_command(command)
	
	if command is CommandMove:
		position += command.direction * command.delta *  MOVE_SPEED

func take_damage(damage: float):
	health -= damage
	if health <= 0.0:
		health = 0.0
		player_health_changed.emit(health)
		player_died.emit()
	else:
		player_health_changed.emit(health)

func take_impulse(impulse: Vector2):
	pass



func start_recording():
	start_of_recording = get_ticks_sec()
	is_recording = true

func stop_recording():
	is_recording = false


func get_ticks_sec() -> float:
	return Time.get_ticks_msec() / 1000.0
