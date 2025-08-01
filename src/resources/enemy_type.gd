extends Resource
class_name EnemyType

# Visual properties
@export var name: String = "Basic Enemy"
@export var texture: Texture2D
@export var scale: Vector2 = Vector2.ONE
@export var modulate_color: Color = Color.WHITE

# Stats
@export var speed: float = 100.0
@export var max_health: float = 100.0
@export var damage: float = 25.0

# Behavior
@export var target_group: String = "loopOrigin"
