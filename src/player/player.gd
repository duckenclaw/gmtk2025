extends Node2D
class_name Player

const PLAYER_BACK = preload("uid://hg2pu7k4m5nv")
const PLAYER_FRONT = preload("uid://u2xov25lfo1c")
const LEFT_HAND_BACK = preload("uid://bd2unw7kylwxh")
const LEFT_HAND_FRONT = preload("uid://cmrjf4p5xyg8j")
const RIGHT_HAND_BACK = preload("uid://c5rh8kvo0xlig")
const RIGHT_HAND_FRONT = preload("uid://cw7irwvgn2fk")

var is_copy: bool = false

signal player_died
signal player_health_changed(health: float)

@export var player_config: PlayerConfig

var position_history: PackedVector2Array
var history: Array[SavedCommand]
var is_recording: bool = false
var start_of_recording: float = 0.0

var actions: Array[Action]
var current_action: Action
@export var selected_action_index: int = 0

var health: float = 0.0
var velocity: Vector2

@onready var actions_node: Node2D = $Actions

@onready var player_sprite: Sprite2D = $PlayerSprite

@onready var hands_bottom_back: Node2D = $HandsBottomBack
@onready var hands_bottom_front: Node2D = $HandsBottomFront
@onready var hands_top_back: Node2D = $HandsTopBack
@onready var hands_top_front: Node2D = $HandsTopFront

@onready var left_hand_back_bottom: Sprite2D = $HandsBottomBack/LeftHandBack
@onready var right_hand_back_bottom: Sprite2D = $HandsBottomBack/RightHandBack
@onready var left_hand_front_bottom: Sprite2D = $HandsBottomFront/LeftHandFront
@onready var right_hand_front_bottom: Sprite2D = $HandsBottomFront/RightHandFront
@onready var left_hand_back_top: Sprite2D = $HandsTopBack/LeftHandBack
@onready var right_hand_back_top: Sprite2D = $HandsTopBack/RightHandBack
@onready var left_hand_front_top: Sprite2D = $HandsTopFront/LeftHandFront
@onready var right_hand_front_top: Sprite2D = $HandsTopFront/RightHandFront




func _ready() -> void:
	if !is_copy:
		player_config = State.player_config
	else:
		set_shadow_colors()
	
	health = player_config.max_health
	
	actions.append_array(actions_node.get_children())
	for action in actions:
		action.player_config = player_config
	
	set_action(actions[selected_action_index])
	
	State.loop_restarted.connect(loop_restarted)

func loop_restarted():
	if is_copy: return
	
	selected_action_index = State.pending_selected_action_index
	set_action(actions[selected_action_index])
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
	update_visuals()

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
		velocity += command.direction * command.delta * player_config.speed * 2.0
		position += command.direction * command.delta * player_config.speed

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
	velocity += impulse * Drag.COMMON_IMPULSE_MULTIPLIER

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

func set_shadow_colors():
	pass

func update_visuals():
	var mouse_direction: Vector2 = (get_global_mouse_position() - hands_top_front.global_position).normalized()
	
	hands_bottom_back.rotation = mouse_direction.angle() + PI / 2
	hands_top_back.rotation = mouse_direction.angle() + PI / 2
	hands_bottom_front.rotation = mouse_direction.angle() - PI / 2
	hands_top_front.rotation = mouse_direction.angle() - PI / 2
	
	var direction_rotated = mouse_direction.rotated(- PI / 2)
	
	var looks_up: bool = mouse_direction.y <= 0
	var right_hand_on_top: bool = not mouse_direction.rotated(- PI / 2).angle() <= 0
	var left_hand_on_top: bool = mouse_direction.rotated(- PI / 2).angle() <= 0
	
	show_left_hand(null)
	
	if looks_up:
		if right_hand_on_top:
			show_right_hand(right_hand_back_top)
		else:
			show_right_hand(right_hand_back_bottom)
		if left_hand_on_top:
			show_left_hand(left_hand_back_top)
		else:
			show_left_hand(left_hand_back_bottom)
	else:
		if right_hand_on_top:
			show_right_hand(right_hand_front_top)
		else:
			show_right_hand(right_hand_front_bottom)
		if left_hand_on_top:
			show_left_hand(left_hand_front_top)
		else:
			show_left_hand(left_hand_front_bottom)
	
	if looks_up:
		player_sprite.texture = PLAYER_BACK
	else:
		player_sprite.texture = PLAYER_FRONT

func show_left_hand(left_hand: Sprite2D):
	for hand in [
		left_hand_back_bottom,
		left_hand_back_top,
		left_hand_front_bottom,
		left_hand_front_top
	]:
		hand.visible = hand == left_hand

func show_right_hand(right_hand: Sprite2D):
	for hand in [
		right_hand_back_bottom,
		right_hand_back_top,
		right_hand_front_bottom,
		right_hand_front_top
	]:
		hand.visible = hand == right_hand
