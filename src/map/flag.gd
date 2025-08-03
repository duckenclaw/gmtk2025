extends Area2D

signal flag_died
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
	is_invincible = true
	invincibility_timer.start(INVINSIBILITY_TIME)
	
	if current_health <= 0.0:
		flag_died.emit()
	
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
