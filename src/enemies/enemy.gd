extends Area2D
class_name Enemy

# Enemy attributes
@export var speed: float = 100.0
@export var max_health: float = 100.0
@export var damage: float = 25.0
@export var texture: Texture2D
@export var target_group: String = "loopOrigin"  # Groups that this enemy can damage

# Current state
var current_health: float
var target_position: Vector2
var is_moving: bool = true
var is_dead: bool = false

# Node references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal enemy_died()
signal enemy_dealt_damage(damage: float)

func _ready():
	current_health = max_health

func _physics_process(delta):
	if is_dead or not is_moving:
		return
	
	# Move towards target position
	var direction = (target_position - global_position).normalized()
	var distance_to_target = global_position.distance_to(target_position)
	
	# Stop moving if close enough to target
	if distance_to_target < 5.0:
		is_moving = false
		return
	
	# Move towards target
	global_position += direction * speed * delta

# Set the target position for the enemy to move towards
func set_target_position(pos: Vector2):
	target_position = pos
	is_moving = true

func _on_body_entered(body):
	if body.is_in_group(target_group):
		body.take_damage(damage)
		enemy_dealt_damage.emit(damage)


func _on_area_entered(area):
	if area.is_in_group(target_group):
		area.take_damage(damage)
		enemy_dealt_damage.emit(damage)
