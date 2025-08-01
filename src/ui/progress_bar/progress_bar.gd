extends ProgressBar
#class_name ProgressBar # hides native class

var res: E.ResType = E.ResType.NONE

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var value_label: Label = $HBoxContainer/ValueLabel
@onready var slash: Label = $HBoxContainer/Slash
@onready var goal_label: Label = $HBoxContainer/GoalLabel


func _process(_delta: float) -> void:
	h_box_container.size = size
	value_label.text = NF.big(value)
	goal_label.text = NF.big(max_value) + " " + E.get_res_name(res)
