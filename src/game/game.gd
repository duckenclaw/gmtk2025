extends Node2D
class_name Game

@onready var game_map: GameMap = $GameMap
@onready var game_ui: GameUi = $GameUi
@onready var camera: Camera2D = $Camera2D

@onready var player: Player = $GameMap/Player
@onready var flag: Area2D = $GameMap/Flag

@onready var recorder_area: RecorderArea = $RecorderArea
@onready var particle_layer: Node2D = $ParticleLayer

@onready var upgrade_menu: UpgradeMenu = $UpgradeMenu


func _ready() -> void:
	Ref.particle_layer = particle_layer
	Ref.recorder = recorder_area
	
	player.player_health_changed.connect(game_ui.player_health_changed)
	player.player_died
	
	flag.origin_health_changed.connect(game_ui.flag_health_changed)
	
	State.start_loop()

func _process(delta: float) -> void:
	update_camera(delta)
	check_next_lvl()

func check_next_lvl():
	if State.exp >= State.exp_to_next_lvl:
		get_tree().paused = true
		State.exp = State.exp - State.exp_to_next_lvl
		State.exp_to_next_lvl *= State.NEXT_LVL_MULTIPLIER
		upgrade_menu.entrance()

func update_camera(delta: float):
	var target = player.global_position / 4.0
	var distance = target.distance_to(camera.global_position)
	camera.global_position = lerp(camera.global_position, target, 0.1 * delta * distance)

func _on_game_ui_create_copy_pressed() -> void:
	if State.current_copies < State.max_copies:
		State.current_copies += 1
		State.all_time_copies += 1
		recorder_area.save_recording(player, State.all_time_copies)
