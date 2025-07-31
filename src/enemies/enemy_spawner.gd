extends Node2D
class_name EnemySpawner

# Enemy scene to instantiate
@export var enemy_scene: PackedScene
@export var spawn_texture: Texture2D

# Spawning parameters
@onready var spawn_timer: Timer = $SpawnTimer
@export var spawn_count: int = 5
@export var spawn_radius: float = 20.0
@export var spawn_interval: float = 2.0

# Target for enemies to move towards
@export var target_node: Node2D

# Internal tracking
var spawned_enemies: Array[Enemy] = []

signal enemy_spawned(enemy: Enemy)
signal all_enemies_dead()

func _ready():
	spawn_timer.wait_time = spawn_interval
	
	# Load default enemy scene if not provided
	if not enemy_scene:
		enemy_scene = preload("res://src/enemies/enemy.tscn")
		
	start_spawning()

# Start spawning enemies
func start_spawning():
	if spawn_timer:
		spawn_timer.start()

# Stop spawning enemies
func stop_spawning():
	if spawn_timer:
		spawn_timer.stop()

# Spawn a single enemy
func spawn_enemy_at_position(pos: Vector2) -> Enemy:
	if not enemy_scene:
		push_error("No enemy scene provided to EnemySpawner")
		return null
	
	# Instantiate enemy
	var enemy = enemy_scene.instantiate() as Enemy
	if not enemy:
		push_error("Failed to instantiate enemy or enemy scene is not an Enemy")
		return null
	
	
	# Position enemy
	enemy.global_position = pos
	
	# Add to scene
	get_parent().add_child(enemy)
	
	# Connect signals
	enemy.enemy_died.connect(_on_enemy_died)
	enemy.enemy_dealt_damage.connect(_on_enemy_dealt_damage)
	
	# Set target if available
	if target_node:
		enemy.set_target_position(target_node.global_position)
	
	# Track enemy
	spawned_enemies.append(enemy)
	
	# Emit signal
	enemy_spawned.emit(enemy)
	
	return enemy

# Spawn enemy at random position around spawner
func spawn_enemy_random() -> Enemy:
	var angle = randf() * TAU
	var distance = randf_range(spawn_radius * 0.5, spawn_radius)
	var spawn_pos = global_position + Vector2(cos(angle), sin(angle)) * distance
	
	return spawn_enemy_at_position(spawn_pos)

# Handle enemy death
func _on_enemy_died(enemy: Enemy):
	spawned_enemies.erase(enemy)
	
	# Check if all enemies are dead
	if spawned_enemies.is_empty():
		all_enemies_dead.emit()

# Handle enemy dealing damage
func _on_enemy_dealt_damage(target: Node, damage_amount: float):
	print("Enemy dealt ", damage_amount, " damage to ", target.name)

# Update all enemy targets
func set_all_enemy_targets(new_target: Vector2):
	for enemy in spawned_enemies:
		if is_instance_valid(enemy):
			enemy.set_target_position(new_target)

# Update target node and redirect all enemies
func set_target_node(new_target: Node2D):
	target_node = new_target
	if target_node:
		set_all_enemy_targets(target_node.global_position)

# Get count of living enemies
func get_living_enemy_count() -> int:
	var count = 0
	for enemy in spawned_enemies:
		if is_instance_valid(enemy) and not enemy.is_dead:
			count += 1
	return count

# Kill all enemies
func kill_all_enemies():
	for enemy in spawned_enemies:
		if is_instance_valid(enemy):
			enemy.die()

# Spawn enemies in a circle formation
func spawn_circle_formation(center: Vector2, radius: float, count: int):
	for i in range(count):
		var angle = (float(i) / count) * TAU
		var pos = center + Vector2(cos(angle), sin(angle)) * radius
		spawn_enemy_at_position(pos)

# Spawn enemies in a line formation
func spawn_line_formation(start: Vector2, end: Vector2, count: int):
	for i in range(count):
		var t = float(i) / max(1, count - 1)
		var pos = start.lerp(end, t)
		spawn_enemy_at_position(pos)


func _on_spawn_timer_timeout():
	if spawned_enemies.size() >= spawn_count:
		stop_spawning()
		return
	
	spawn_enemy_random()
