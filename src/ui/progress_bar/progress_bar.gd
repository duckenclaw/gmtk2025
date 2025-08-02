extends ProgressBar
#class_name ProgressBar # hides native class

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var value_label: Label = $HBoxContainer/ValueLabel
@onready var slash: Label = $HBoxContainer/Slash
@onready var max_label: Label = $HBoxContainer/GoalLabel


func _process(_delta: float) -> void:
	h_box_container.size = size
	
	value_label.text = str(int(value))
	max_label.text = str(int(max_value))
