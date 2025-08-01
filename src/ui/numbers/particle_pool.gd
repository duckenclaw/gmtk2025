extends Node
#class_name ParticlePool

enum ParticleType {
	ENEMY_TAKES_DAMAGE,
	PLAYER_TAKES_DAMAGE,
	FLAG_TAKES_DAMAGE,
	PLAYER_HEAL,
	FLAG_HEAL
}

const NUMBER_CHANGE_PARTICLE = preload("res://src/ui/numbers/number_change_particle.tscn")

var stashed_change_particles: Array[NumberChangeParticle]

func spawn_number_particle(g_pos: Vector2, res: ParticleType, amount: float):
	if stashed_change_particles.is_empty():
		stashed_change_particles.append(create_number_particle(res, amount))
		#print("created new particle")
	
	var particle: NumberChangeParticle = stashed_change_particles.pop_back()
	particle.setup(g_pos, res, amount)

func create_number_particle(res: ParticleType, amount: float) -> NumberChangeParticle:
	var particle: NumberChangeParticle = NUMBER_CHANGE_PARTICLE.instantiate()
	Ref.particle_layer.add_child(particle)
	particle.was_stashed.connect(_change_particle_was_stashed.bind(particle))
	return particle

func _change_particle_was_stashed(particle: NumberChangeParticle):
	stashed_change_particles.append(particle)
