extends Node2D
class_name EnemySpawner

# Enemy scene to instantiate
@export var enemy_scene: PackedScene

# Enemy type configuration
@export var current_enemy_types: Array[EnemyType] = []
@export var enemy_type_weights: Array[float] = []

# Spawning parameters
@onready var spawn_timer: Timer = $SpawnTimer
@export var spawn_count: int = 5
@export var enemy_pack_count: int = 1
@export var spawn_radius: float = 60.0
@export var spawn_interval: float = 1.0

# Target for enemies to move towards
@export var target_node: Node2D

# Internal tracking
var spawned_enemies: Array[Enemy] = []
var remaining_spawns: int = 0

signal enemy_spawned(enemy: Enemy)
signal all_enemies_dead()

func _ready():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(_on_spawner_timer_timeout)

# ========== MAIN PIPELINE ==========

# 1. Start the spawning process
func start_spawning():
	remaining_spawns = spawn_count
	if spawn_timer and remaining_spawns > 0:
		spawn_timer.start()

# 2. Configure enemy types with weights for random distribution
func configure_enemy_types(types: Array[EnemyType], weights: Array[float] = []):
	current_enemy_types = types
	enemy_type_weights = weights

# 3. Timer callback - spawn pack of enemies in circular pattern
func _on_spawner_timer_timeout():
	if remaining_spawns <= 0:
		spawn_timer.stop()
		return
	
	_spawn_enemy_pack()
	remaining_spawns -= 1

# 4. Check if all enemies are dead and spawning is complete
func _check_wave_complete():
	if remaining_spawns <= 0 and get_living_enemy_count() == 0:
		all_enemies_dead.emit()

# ========== CORE SPAWNING LOGIC ==========

# Spawn a pack of enemies in circular formation
func _spawn_enemy_pack():
	var spawn_angle = randf() * TAU
	var spawn_distance = Random.f_range(spawn_radius, spawn_radius * 1.5)
	var pack_center = global_position + Random.point_on_radius(spawn_distance)
	
	var enemy_type = _get_weighted_random_enemy_type()
	
	for i in range(enemy_pack_count):
		var angle = (float(i) / enemy_pack_count) * TAU
		var pos = pack_center + Random.point_within_radius(300.0)  # Small spacing between pack members
		var enemy = _create_enemy_at_position(pos, enemy_type)

# Create a single enemy with type configuration
func _create_enemy_at_position(pos: Vector2, enemy_type: EnemyType) -> Enemy:
	if not enemy_scene:
		push_error("No enemy scene provided to EnemySpawner")
		return null
	
	var enemy = enemy_scene.instantiate() as Enemy
	enemy.main_target = target_node
	if not enemy:
		push_error("Failed to instantiate enemy or enemy scene is not an Enemy")
		return null
	
	# Position and add to scene
	enemy.global_position = pos
	get_parent().get_parent().add_child(enemy)
	
	# Configure enemy with type
	_apply_enemy_type(enemy, enemy_type)
	
	# Connect signals
	enemy.enemy_died.connect(_on_enemy_died)
	enemy.enemy_dealt_damage.connect(_on_enemy_dealt_damage)
	
	# Set target
	if enemy.main_target:
		enemy.set_target_position(target_node.global_position)
	
	# Track enemy
	spawned_enemies.append(enemy)
	enemy_spawned.emit(enemy)
	
	return enemy

# Get random enemy type based on weights
func _get_weighted_random_enemy_type() -> EnemyType:
	if current_enemy_types.is_empty():
		push_error("No enemy types configured")
		return null
	
	# If no weights, use equal probability
	if enemy_type_weights.is_empty():
		return current_enemy_types[randi() % current_enemy_types.size()]
	
	# Weighted random selection
	var total_weight = 0.0
	for weight in enemy_type_weights:
		total_weight += weight
	
	var random_value = randf() * total_weight
	var current_weight = 0.0
	
	for i in range(current_enemy_types.size()):
		if i < enemy_type_weights.size():
			current_weight += enemy_type_weights[i]
		else:
			current_weight += 1.0  # Default weight
		
		if random_value <= current_weight:
			return current_enemy_types[i]
	
	return current_enemy_types[0]  # Fallback

# Apply enemy type stats and visuals
func _apply_enemy_type(enemy: Enemy, enemy_type: EnemyType):
	if not enemy or not enemy_type:
		return
	
	# Apply stats
	enemy.speed = enemy_type.speed
	enemy.max_health = enemy_type.max_health
	enemy.current_health = enemy_type.max_health
	enemy.damage = enemy_type.damage
	enemy.target_groups = enemy_type.target_groups
	
	# Apply visual properties
	if enemy_type.texture and enemy.sprite:
		enemy.enemy_texture = enemy_type.texture
		enemy.sprite.texture = enemy_type.texture

# ========== EVENT HANDLERS ==========

func _on_enemy_died(enemy: Enemy):
	_check_wave_complete()

func _on_enemy_dealt_damage(target: Node, damage_amount: float):
	pass
	#print("Enemy dealt ", damage_amount, " damage to ", target.name)

# ========== UTILITY FUNCTIONS ==========

func stop_spawning():
	if spawn_timer:
		spawn_timer.stop()

func get_living_enemy_count() -> int:
	var count = 0
	for enemy in spawned_enemies:
		if is_instance_valid(enemy) and not enemy.is_dead:
			count += 1
	return count

func kill_all_enemies():
	for enemy in spawned_enemies:
		if is_instance_valid(enemy):
			enemy.die()

func set_target_node(new_target: Node2D):
	target_node = new_target
	if target_node:
		_update_all_enemy_targets(target_node.global_position)

func _update_all_enemy_targets(new_target: Vector2):
	for enemy in spawned_enemies:
		if is_instance_valid(enemy):
			enemy.set_target_position(new_target)

# ========== WAVE CONFIGURATION ==========

func configure_from_wave(wave_config: WaveConfig):
	if not wave_config:
		return
	
	configure_enemy_types(wave_config.enemy_types, wave_config.enemy_type_weights)
	spawn_count = wave_config.enemies_per_spawner
	enemy_pack_count = wave_config.enemy_pack_count
	spawn_interval = wave_config.spawn_interval
	spawn_timer.wait_time = spawn_interval
