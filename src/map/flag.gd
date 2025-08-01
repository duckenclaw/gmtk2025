extends Area2D

@export var max_health: float = 100.0
@export var current_health: float

@onready var invincibility_timer = $InvincibilityTimer
var is_invincible: bool = false

func _ready():
	current_health = max_health


func _on_invincibility_timer_timeout():
	print("flag not invincible")
	is_invincible = false
	invincibility_timer.stop()
	
func take_damage(incoming_damage: float):
	if is_invincible:
		return false
	
	current_health -= incoming_damage
	print("FLAG TOOK: " + str(incoming_damage))
	print("CURRENT HEALTH: " + str(current_health) + "/" + str(max_health))
	is_invincible = true
	invincibility_timer.start(3)
	print("flag invincible")
	
