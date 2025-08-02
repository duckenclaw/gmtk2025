extends PanelContainer
class_name CopyButton

var record: Record
var copy: Player

@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	if record != null:
		setup_record()
	else:
		setup_empty()

func setup_record():
	label.text = record.id

func setup_empty():
	pass
