extends CanvasLayer
class_name GameUi

signal action_selected()
signal create_copy_pressed

@onready var flag_progress_bar: ProgressBar = $HealthContainer/FlagProgressBar
@onready var player_progress_bar: ProgressBar = $HealthContainer/PlayerProgressBar
@onready var create_copy_button: Button = $CreateCopyButton
@onready var time_label: Label = $TimeLabel



func _ready() -> void:
	player_progress_bar.value = State.player_max_health
	flag_progress_bar.value = State.flag_max_health


func _process(_delta: float) -> void:
	player_progress_bar.max_value = State.player_max_health
	flag_progress_bar.max_value = State.flag_max_health
	
	time_label.text = str(int(State.LOOP_TIME - State.loop_progress_sec + 1))
	

func player_health_changed(health: float):
	player_progress_bar.value = health
	

func flag_health_changed(health: float):
	flag_progress_bar.value = health


func _on_create_copy_button_pressed() -> void:
	create_copy_pressed.emit()
