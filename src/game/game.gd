extends Node2D
class_name Game

const PLAYER = preload("uid://cni2a6p1fkqef")

var player: Player

@onready var game_map: GameMap = $GameMap
@onready var game_ui: GameUi = $GameUi
@onready var camera: Camera2D = $Camera2D

@onready var flag: Area2D = $GameMap/Flag

@onready var recorder_area: RecorderArea = $RecorderArea
@onready var particle_layer: Node2D = $ParticleLayer

@onready var upgrade_menu: UpgradeMenu = $UpgradeMenu
@onready var rewrite_copy_menu: RewriteCopyMenu = $RewriteCopyMenu
@onready var game_over_screen: GameOverScreen = $GameOverScreen


func _ready() -> void:
	Sound.start_soundtrack()
	Ref.particle_layer = particle_layer
	Ref.recorder = recorder_area
	spawn_player()
	
	
	flag.origin_health_changed.connect(game_ui.flag_health_changed)
	flag.flag_died.connect(flag_died)
	
	State.loop_restarted.connect(update_current_action)
	State.start_loop()
	
	(create_tween()
		.tween_property(camera, "zoom", Vector2(1.35, 1.35), 5.0)
		.from(Vector2(4, 4))
		)
	


func flag_died():
	game_over_screen.show_game_over()


func spawn_player():
	player = PLAYER.instantiate()
	game_map.add_child(player)
	player.player_health_changed.connect(game_ui.player_health_changed)
	player.player_died.connect(on_player_died)

func on_player_died():
	if State.max_copies == 0:
		flag_died()
		return 
	
	get_tree().paused = true
	rewrite_copy_menu.open_remove_copy_on_death(player)
	await State.loop_restarted
	spawn_player()

func _process(delta: float) -> void:
	update_camera(delta)
	check_next_lvl()
	check_action_changed()
	check_record_pressed()

func check_action_changed():
	for i in [1, 2, 3, 4, 5]:
		if Input.is_action_just_pressed("number_" + str(i)):
			var action_index = i - 1
			if Action.get_action_enabled(action_index):
				print("Selected action number_" + str(action_index))
				State.pending_selected_action_index = action_index

func check_record_pressed():
	if Input.is_action_just_pressed("record"):
		save_record()

func update_current_action():
	State.selected_action_index = State.pending_selected_action_index

func check_next_lvl():
	if State.exp >= State.exp_to_next_lvl:
		get_tree().paused = true
		State.exp = State.exp - State.exp_to_next_lvl
		State.exp_to_next_lvl *= State.NEXT_LVL_MULTIPLIER
		upgrade_menu.entrance()

func update_camera(delta: float):
	if not is_instance_valid(player):
		return
		
	var target = player.global_position / 2.0
	var distance = target.distance_to(camera.global_position)
	camera.global_position = lerp(camera.global_position, target, 0.1 * delta * distance)

func save_record() -> void:
	if not is_instance_valid(player) or player.is_dead:
		return
	
	if State.current_copies < State.max_copies:
		State.current_copies += 1
		State.all_time_copies += 1
		recorder_area.save_recording(player, State.all_time_copies)
	else:
		get_tree().paused = true
		rewrite_copy_menu.open_rewrite_copy(player)
