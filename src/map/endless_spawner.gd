extends Node2D
class_name EndlessSpawner

const HEALTH_COEF: float = 0.3
const SPEED_COEF: float = 0.3
const SCALE_COEF: float = 0.5

const ENEMY = preload("uid://cgpkr8nvf4qyk")

@export var enemy_type: EnemyType


func _ready() -> void:
	while true:
		_create_enemy_at_position(Random.point_on_radius(1500.0), enemy_type)
		await WaitUtil.wait(0.2)

func _create_enemy_at_position(pos: Vector2, enemy_type: EnemyType) -> Enemy:
	var enemy: Enemy = ENEMY.instantiate()
	enemy.main_target = self
	if not enemy:
		push_error("Failed to instantiate enemy or enemy scene is not an Enemy")
		return null
	
	# Position and add to scene
	enemy.global_position = pos
	get_parent().get_parent().add_child(enemy)
	
	# Configure enemy with type
	_apply_enemy_type(enemy, enemy_type)
	
	# Set target
	if enemy.main_target:
		enemy.set_target_position(Vector2.ZERO)
	
	return enemy

# Apply enemy type stats and visuals
func _apply_enemy_type(enemy: Enemy, enemy_type: EnemyType):
	if not enemy or not enemy_type:
		return
	
	# Apply stats
	enemy.speed = enemy_type.speed * SPEED_COEF
	enemy.max_health = enemy_type.max_health
	enemy.current_health = enemy_type.max_health * HEALTH_COEF
	enemy.damage = enemy_type.damage
	enemy.target_groups = enemy_type.target_groups
	enemy.scale = enemy_type.scale * SCALE_COEF
	
	# Apply visual properties
	if enemy_type.texture and enemy.sprite:
		enemy.enemy_texture = enemy_type.texture
		enemy.sprite.texture = enemy_type.texture
		enemy.sprite.modulate = enemy_type.modulate_color
