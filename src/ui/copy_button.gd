extends PanelContainer
class_name CopyButton

var record: Record
var copy: Player

@onready var label: Label = $MarginContainer/Label
@onready var player_silouette: Container = $MarginContainer/Container


func _ready() -> void:
	if record != null:
		setup_record()
	else:
		setup_empty()

func setup_record():
	label.text = record.id
	player_silouette.modulate = record.color

func setup_empty():
	pass


func _on_click_listener_mouse_pressed() -> void:
	pass # Replace with function body.
