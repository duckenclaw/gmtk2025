extends CanvasLayer
class_name GameUi

@onready var flag_progress_bar: ProgressBar = $HealthContainer/FlagProgressBar
@onready var player_progress_bar: ProgressBar = $HealthContainer/PlayerProgressBar

func _process(_delta: float) -> void:
	player_progress_bar.max_value = State.player_max_health
	flag_progress_bar.max_value = State.flag_max_health

func _ready() -> void:
	player_progress_bar.value = State.player_max_health
	flag_progress_bar.value = State.flag_max_health

func player_health_changed(health: float):
	player_progress_bar.value = health
	

func flag_health_changed(health: float):
	flag_progress_bar.value = health
