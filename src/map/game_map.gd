extends Node2D
class_name GameMap

# ========== SPAWNER REFERENCES ==========
@onready var central_spawner: EnemySpawner = $EnemySpawners/CentralEnemySpawner
@onready var north_spawner: EnemySpawner = $EnemySpawners/NorthEnemySpawner
@onready var south_spawner: EnemySpawner = $EnemySpawners/SouthEnemySpawner
@onready var west_spawner: EnemySpawner = $EnemySpawners/WestEnemySpawner
@onready var east_spawner: EnemySpawner = $EnemySpawners/EastEnemySpawner

# ========== WAVE CONFIGURATION ==========
@export var wave_configs: Array[WaveConfig] = []
@export var default_enemy_types: Array[Enemy] = []

# ========== WAVE MANAGEMENT ==========
var current_wave_index: int = 0
var active_waves: Array[WaveData] = []
var wave_timer: Timer
var repeat_timer: Timer

# ========== SIGNALS ==========
signal wave_started(wave_config: WaveConfig)
signal wave_completed(wave_config: WaveConfig)
signal all_waves_completed()

# Internal wave tracking
class WaveData:
	var config: WaveConfig
	var spawners: Array[EnemySpawner]
	var enemies_spawned: int = 0
	var is_active: bool = false
	var next_spawn_time: float
	
	func _init(wave_config: WaveConfig, spawner_list: Array[EnemySpawner]):
		config = wave_config
		spawners = spawner_list
		next_spawn_time =  config.spawn_interval

@onready var player: Player = $Player
@onready var flag: Area2D = $Flag


func _ready():
	setup_timers()
	
	# Start the first two repeating waves
	if wave_configs.size() >= 2:
		start_initial_waves()

func setup_timers():
	# Wave management timer
	wave_timer = Timer.new()
	wave_timer.wait_time = 0.1  # Check every 100ms
	wave_timer.timeout.connect(_update_waves)
	add_child(wave_timer)
	wave_timer.start()
	
	# Repeat timer for repeating waves
	repeat_timer = Timer.new()
	repeat_timer.one_shot = true
	repeat_timer.timeout.connect(_handle_wave_repeat)
	add_child(repeat_timer)

func get_spawner_by_direction(direction: String) -> EnemySpawner:
	match direction.to_lower():
		"central":
			return central_spawner
		"north":
			return north_spawner
		"south":
			return south_spawner
		"west":
			return west_spawner
		"east":
			return east_spawner
		_:
			push_error("Unknown spawner direction: " + direction)
			return null

# ========== WAVE MANAGEMENT ==========

func start_initial_waves():
	current_wave_index = 0
	start_next_wave()
	#for wave in wave_configs.size():
		#start_wave(wave)

func start_wave(wave_index: int) -> bool:
	if wave_index >= wave_configs.size():
		push_error("Wave index out of range: " + str(wave_index))
		return false
	
	var wave_config = wave_configs[wave_index]
	if not wave_config.validate():
		push_error("Wave configuration invalid: " + wave_config.wave_name)
		return false
	
	# Get spawners for this wave
	var spawners: Array[EnemySpawner] = []
	for direction in wave_config.spawner_directions:
		var spawner = get_spawner_by_direction(direction)
		print(spawner)
		if spawner:
			spawners.append(spawner)
	
	if spawners.is_empty():
		push_error("No valid spawners found for wave: " + wave_config.wave_name)
		return false
	
	# Create wave data
	var wave_data = WaveData.new(wave_config, spawners)
	wave_data.is_active = true
	active_waves.append(wave_data)
	
	# Configure spawners
	for spawner in spawners:
		spawner.configure_from_wave(wave_config)
		if wave_config.delay_before_start > 0:
			# TODO: Add delay functionality
			pass
		else:
			spawner.start_spawning()
			print(spawner.spawn_count)
	
	wave_started.emit(wave_config)
	print("Started wave: ", wave_config.wave_name)
	return true

func stop_wave(wave_data: WaveData):
	if not wave_data:
		return
	
	wave_data.is_active = false
	
	# Stop all spawners for this wave
	for spawner in wave_data.spawners:
		spawner.stop_spawning()
	
	# Remove from active waves
	active_waves.erase(wave_data)
	
	wave_completed.emit(wave_data.config)
	print("Completed wave: ", wave_data.config.wave_name)
	
	# Schedule repeat if needed
	if wave_data.config.is_repeating:
		repeat_timer.wait_time = wave_data.config.repeat_interval
		repeat_timer.start()

func _update_waves():
	
	for wave_data in active_waves.duplicate():  # Duplicate to avoid modification during iteration
		if not wave_data.is_active:
			continue
		
		var config = wave_data.config
		
		# Check if total enemies spawned
		if config.total_enemies > 0 and wave_data.enemies_spawned >= config.total_enemies:
			var all_enemies_dead = true
			for spawner in wave_data.spawners:
				if spawner.get_living_enemy_count() > 0:
					all_enemies_dead = false
					break
			
			if all_enemies_dead:
				stop_wave(wave_data)
				continue

func _handle_wave_repeat():
	# Find a completed repeating wave to restart
	# For now, restart the first two waves
	#if wave_configs.size() >= 2:
		#start_wave(0)
		#start_wave(1)
	pass

# ========== PUBLIC INTERFACE ==========

func start_next_wave() -> bool:
	print_wave_status()
	if current_wave_index >= wave_configs.size():
		all_waves_completed.emit()
		return false
	
	# Disable current wave (remove to start all waves every time)
	if active_waves.size() > 1:
		stop_wave(active_waves[1])
	
	var success = start_wave(current_wave_index)
	print("started wave with index " + str(current_wave_index))
	print_wave_status()
	if success:
		current_wave_index += 1
	return success

func stop_all_waves():
	for wave_data in active_waves.duplicate():
		stop_wave(wave_data)

func add_wave_config(config: WaveConfig):
	wave_configs.append(config)

func get_active_wave_count() -> int:
	return active_waves.size()

func get_total_living_enemies() -> int:
	var total = 0
	var spawners = [central_spawner, north_spawner, south_spawner, west_spawner, east_spawner]
	for spawner in spawners:
		if spawner:
			total += spawner.get_living_enemy_count()
	return total

# ========== DEBUGGING ==========

func print_wave_status():
	print("=== WAVE STATUS ===")
	print("Active wave: ", active_waves)
	for wave_data in active_waves:
		print("  - ", wave_data.config.wave_name, " (", wave_data.enemies_spawned, " spawned)")
	print("Total enemies: ", get_total_living_enemies())


func _on_enemy_spawned(enemy: Enemy):
	active_waves[0].enemies_spawned += 1
	print("spawned enemy: " + enemy.name)

func _on_wave_timer_timeout():
	if get_total_living_enemies() <= 0:
		start_next_wave()
