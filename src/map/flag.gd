extends Area2D

signal origin_health_changed(health: float)

const INVINSIBILITY_TIME: float = 0.2

var current_health: float = State.flag_max_health

@onready var invincibility_timer = $InvincibilityTimer
var is_invincible: bool = false


func _on_invincibility_timer_timeout():
	#print("flag not invincible")
	is_invincible = false

func take_damage(incoming_damage: float):
	if is_invincible:
		return false
	
	current_health -= incoming_damage
	#print("FLAG TOOK: " + str(incoming_damage))
	#print("CURRENT HEALTH: " + str(current_health) + "/" + str(State.flag_max_health))
	is_invincible = true
	#print("flag invincible")
	invincibility_timer.start(INVINSIBILITY_TIME)
	
	origin_health_changed.emit(current_health)
	ParticlePool.spawn_number_particle(
		global_position, 
		ParticlePool.ParticleType.FLAG_TAKES_DAMAGE, 
		incoming_damage
		)



func _on_regen_timer_timeout() -> void:
	var regen = State.flag_regen
	if current_health < State.flag_max_health:
		ParticlePool.spawn_number_particle(
			global_position, 
			ParticlePool.ParticleType.FLAG_HEAL, 
			regen
			)
		current_health += regen
	
	origin_health_changed.emit(current_health)
