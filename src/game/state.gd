extends Node
#class_name State # Autoload

const INITIAL_NEXT_LVL_EXP: float = 10.0
const NEXT_LVL_MULTIPLIER: float = 1.2
const LOOP_TIME: float = 10.0

signal loop_restarted
signal loop_progress(value: float, seconds: float) # 0 to 1

var loop_index: int = 0
var loop_progress_sec: float = 0.0
var loop_value: float = 0.0 # 0 to 1

var player_max_health: float = 100.0
var flag_max_health: float = 300.0

var max_copies: int = 5
var current_copies: int = 0
var all_time_copies: int = 0

var player_is_home: bool = false

var fire_available: bool = true
var black_hole_available: bool = false

var exp_to_next_lvl: float = INITIAL_NEXT_LVL_EXP
var exp: float = 0.0

# for real player
var player_config: PlayerConfig = PlayerConfig.new()


func _ready() -> void:
	pass

func start_loop():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_method(on_loop_progress, 0.0, 1.0, LOOP_TIME)
	tween.loop_finished.connect(on_loop_restarted)
	on_loop_restarted(0)

func on_loop_restarted(loop: int):
	loop_index = loop
	print("LOOP RESTARTED: " + str(loop))
	loop_restarted.emit()

func on_loop_progress(value: float):
	#print("LOOP PROGRESS: " + str(value))
	loop_progress.emit(value, value * LOOP_TIME)
	loop_value = value
	loop_progress_sec = value * LOOP_TIME
