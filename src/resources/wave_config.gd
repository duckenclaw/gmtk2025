extends Resource
class_name WaveConfig

# Wave identification
@export var wave_name: String = "Wave 1"
@export var wave_number: int = 1

# Spawner configuration
@export var spawner_directions: Array[String] = ["north", "south"]  # Which spawners to use
@export var enemy_types: Array[EnemyType] = []  # Types of enemies in this wave
@export var enemy_type_weights: Array[float] = []  # Probability weights for each enemy type

# Timing
@export var spawn_interval: float = 2.0  # Time between spawns
@export var delay_before_start: float = 0.0  # Delay before wave starts

# Enemy counts
@export var total_enemies: int = 5  # Total enemies to spawn (-1 for infinite)
@export var enemies_per_spawner: int = -1  # Enemies per spawner (-1 for auto-distribute)
@export var enemy_pack_count: int = 1

# Wave behavior
@export var is_repeating: bool = false  # Does this wave repeat?
@export var repeat_interval: float = 60.0  # Time between repeats

# Conditions
@export var boss_wave: bool = false  # Is this a boss wave?

func get_random_enemy_type() -> EnemyType:
	if enemy_types.is_empty():
		return null
	
	# If no weights specified, use equal probability
	if enemy_type_weights.is_empty():
		return enemy_types[randi() % enemy_types.size()]
	
	# Use weighted random selection
	var total_weight = 0.0
	for weight in enemy_type_weights:
		total_weight += weight
	
	var random_value = randf() * total_weight
	var current_weight = 0.0
	
	for i in range(enemy_types.size()):
		if i < enemy_type_weights.size():
			current_weight += enemy_type_weights[i]
		else:
			current_weight += 1.0  # Default weight
		
		if random_value <= current_weight:
			return enemy_types[i]
	
	# Fallback
	return enemy_types[0]

func validate() -> bool:
	if enemy_types.is_empty():
		push_error("Wave " + wave_name + " has no enemy types configured")
		return false
	
	if spawner_directions.is_empty():
		push_error("Wave " + wave_name + " has no spawner directions configured")
		return false
	
	return true
