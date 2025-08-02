extends Node

signal mouse_pressed

var _mouse_inside := false
var _mouse_down := false
var _was_pressed := false

func _ready() -> void:
	var parent_control := get_parent()
	if not parent_control is Control:
		push_error("MousePressListener must be a child of a Control node.")
		return

	# Connect to parent's mouse signals
	parent_control.mouse_entered.connect(_on_mouse_entered)
	parent_control.mouse_exited.connect(_on_mouse_exited)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_mouse_down = true
		else:
			_mouse_down = false
		_check_state()

func _on_mouse_entered() -> void:
	_mouse_inside = true
	_check_state()

func _on_mouse_exited() -> void:
	_mouse_inside = false
	_check_state()

func _check_state() -> void:
	var pressed = _mouse_inside and _mouse_down
	if pressed != _was_pressed:
		_was_pressed = pressed
		if pressed:
			mouse_pressed.emit()
