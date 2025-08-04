extends Area2D
class_name Enemy

const EXP = preload("uid://c86ubuma3ax4m")

# Enemy attributes
@export var speed: float = 100.0
@export var max_health: float = 100.0
@export var damage: float = 25.0
@export var enemy_texture: CompressedTexture2D
@export var target_groups: Array[String] = ["loopOrigin", "player"]  # Groups that this enemy can damage

# Current state
var current_health: float
var main_target: Node2D
var target: Node2D
var target_position: Vector2
var is_moving: bool = true
var is_dead: bool = false
var is_invincible: bool = false
var velocity: Vector2 = Vector2.ZERO

var nearby_enemies: Array[Enemy]
var min_enemy_distance: float = Random.f_range(30, 70)

# Node references
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var invincibility_timer: Timer = $InvincibilityTimer

signal enemy_died()
signal enemy_dealt_damage(target: Node, damage: float)

func _ready():
	current_health = max_health / 2.0
	target = main_target
	$AnimationPlayer.speed_scale = Random.f_range(0.95, 1.05)

func _physics_process(delta):
	if is_dead:
		return
	
	global_position += velocity
	velocity = Drag.drag(velocity)
	
	# Attack 
	for area in get_overlapping_areas():
		if NodeUtils.has_intersecting_groups(area, target_groups):
			area.take_damage(damage)
			enemy_dealt_damage.emit(area, damage)
	
	if not is_moving:
		return
	
	var away_vector: Vector2 = Vector2.ZERO
	for enemy in nearby_enemies:
		if global_position.distance_to(enemy.global_position) < min_enemy_distance:
			away_vector -= global_position.direction_to(enemy.global_position)
	away_vector.normalized()
	
	# Move towards target position
	if target:
		set_target_position(target.global_position)
	var direction = ((target_position - global_position).normalized() + away_vector.normalized()).normalized()
	var distance_to_target = global_position.distance_to(target_position)
	
	# Stop moving if close enough to target
	if distance_to_target < 30.0:
		is_moving = false
		return
	
	# Move towards target
	global_position += direction * speed * delta

# Set the target position for the enemy to move towards
func set_target_position(pos: Vector2):
	target_position = pos
	is_moving = true
	
func take_damage(incoming_damage: float):
	if is_invincible or is_dead:
		return false
	
	current_health -= incoming_damage
	ParticlePool.spawn_number_particle(
		global_position, 
		ParticlePool.ParticleType.ENEMY_TAKES_DAMAGE, 
		incoming_damage
		)
	
	if current_health <= 0:
		is_dead = true
		print(name + " ENEMY DEAD")
		enemy_died.emit(self)
		drop_exp()
		queue_free()
	return true

func take_impulse(impulse: Vector2):
	velocity += impulse * Drag.COMMON_IMPULSE_MULTIPLIER

func drop_exp():
	var exp = EXP.instantiate()
	get_parent().add_child(exp)
	exp.global_position = global_position

func _on_body_entered(body: PhysicsBody2D):
	if NodeUtils.has_intersecting_groups(body, target_groups):
		body.take_damage(damage)
		enemy_dealt_damage.emit(body, damage)


func _on_area_entered(area: Area2D):
	if NodeUtils.has_intersecting_groups(area, target_groups):
		area.take_damage(damage)
		enemy_dealt_damage.emit(area, damage)


func _on_invincibility_timer_timeout():
	print(name + " not invincible")
	is_invincible = false
	invincibility_timer.stop()


func _on_detection_area_entered(area):
	if area.is_in_group("player"):
		target = area
		if NodeUtils.has_intersecting_groups(area, target_groups):
			set_target_position(target.global_position)
	if area.is_in_group("enemy"):
		nearby_enemies.append(area)


func _on_disinterest_timer_timeout():
	if main_target == null or not is_instance_valid(main_target):
		push_error("Enemy main target is null somehos")
	
	target = main_target
	# after waiting target can change already
	#await WaitUtil.wait(0.5)
	set_target_position(target.global_position)


func _on_detection_area_exited(area: Area2D):
	if area.is_in_group("player"):
		$DetectionArea/DisinterestTimer.start(0.5)
	if area.is_in_group("enemy"):
		nearby_enemies.erase(area)
