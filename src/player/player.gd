extends Node2D
class_name Player

const MOVE_SPEED = 400.0

var is_copy: bool = false

signal player_died
signal player_health_changed(health: float)

var position_history: PackedVector2Array
var history: Array[SavedCommand]
var is_recording: bool = false
var start_of_recording: float = 0.0

var actions: Array[Action]
var current_action: Action

var health := State.player_max_health

var velocity: Vector2

@onready var actions_node: Node2D = $Actions


func _ready() -> void:
	actions.append_array(actions_node.get_children())
	set_action(actions[1])
	State.loop_restarted.connect(loop_restarted)

func loop_restarted():
	if is_copy: return
	
	global_position = Vector2.ZERO
	stop_recording()
	start_recording()

func set_action(action: Action):
	for other in actions:
		other.visible = false
		other.active = false
	current_action = action
	current_action.visible = true
	current_action.active = true

func _process(delta: float) -> void:
	if is_recording and not is_copy:
		Ref.recorder.display_path(position_history, Color.WEB_MAROON, "player")


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	velocity = Drag.drag(velocity)
	
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
	
	if is_recording:
		position_history.append(global_position)


func accept_command(command: Command): 
	if is_recording:
		var since_start = get_ticks_sec() - start_of_recording
		history.append(SavedCommand.new(since_start, command))
	
	current_action.accept_command(command)
	
	if command is CommandMove:
		velocity += command.direction * command.delta *  MOVE_SPEED * 2.0
		position += command.direction * command.delta *  MOVE_SPEED

func take_damage(damage: float):
	health -= damage
	if health <= 0.0:
		health = 0.0
		if not is_copy:
			player_health_changed.emit(health)
			player_died.emit()
	else:
		if not is_copy:
			player_health_changed.emit(health)

func take_impulse(impulse: Vector2):
	pass

func start_recording():
	Ref.recorder.remove_path("player")
	history = []
	position_history = []
	position_history.append(Vector2.ZERO)
	
	start_of_recording = get_ticks_sec()
	is_recording = true

func stop_recording():
	is_recording = false


func get_ticks_sec() -> float:
	return Time.get_ticks_msec() / 1000.0


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("center_area"):
		State.player_is_home = true


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("center_area"):
		#State.player_is_home = false
		pass
