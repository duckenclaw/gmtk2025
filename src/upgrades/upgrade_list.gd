class_name UpgradeList

const AIR_BIG = preload("uid://crsjay82i3ldi")
const DARK_BIG = preload("uid://xwiulgb2olth")
const FIRE_BIG = preload("uid://chby0tlyn6ij0")
const LIGHT_BIG = preload("uid://cctwth2haff43")
const ROCK_BIG = preload("uid://c1x4td4yx8npc")
const WATER_BIG = preload("uid://dhx4fp48nt5ty")

static func get_upgrade_list() -> Array[Upgrade]:
	var list: Array[Upgrade]
	
	for i in 3:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "More fire damage!"
		upgrade.texture = FIRE_BIG
		upgrade.mult = 1.4
		upgrade.condition = func(): return State.fire_available
		upgrade.action = func(): State.player_config.fire_damage *= 1.4
		
		list.append(upgrade)
	
	
	
	
	for i in 3: 
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "BLACK HOLE"
		upgrade.texture = DARK_BIG
		upgrade.desctiption = "Deals small damage. Sucks enemies into the center"
		upgrade.condition = func(): return State.black_hole_available != true
		upgrade.action = func(): State.black_hole_available = true
		
		list.append(upgrade)
	
	for i in 3:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "Wider black hole!"
		upgrade.texture = DARK_BIG
		upgrade.mult = 1.4
		upgrade.condition = func(): return State.black_hole_available
		upgrade.action = func(): State.player_config.black_hole_radius *= 1.4
		
		list.append(upgrade)
	
	
	
	
	for i in 3: 
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "WAVE"
		upgrade.texture = WATER_BIG
		upgrade.desctiption = "Deals small damage. Pushes enemies far away"
		upgrade.condition = func(): return State.wave_available != true
		upgrade.action = func(): State.wave_available = true
		
		list.append(upgrade)
	
	
	for i in 3:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "Wider wave!"
		upgrade.texture = WATER_BIG
		upgrade.mult = 1.4
		upgrade.condition = func(): return State.wave_available
		upgrade.action = func(): State.player_config.wave_width *= 1.4
		
		list.append(upgrade)
	
	
	
	
	for i in 3: 
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "LIGHT LASER"
		upgrade.texture = LIGHT_BIG
		upgrade.desctiption = "Deals high damage. Attacks in a straight line"
		upgrade.condition = func(): return State.laser_available != true
		upgrade.action = func(): State.laser_available = true
		
		list.append(upgrade)
	
	#for i in 3:
		#var upgrade: Upgrade = Upgrade.new()
		#
		#upgrade.title = "More laser damage!"
		#upgrade.texture = LIGHT_BIG
		#upgrade.mult = 1.4
		#upgrade.condition = func(): return State.wave_available
		#upgrade.action = func(): State.player_config.wave_width *= 1.4
		#
		#list.append(upgrade)
	#
	
	
	for i in 3: 
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "ROCK"
		upgrade.texture = ROCK_BIG
		upgrade.desctiption = "Deals very high damage on a distance"
		upgrade.condition = func(): return State.rock_available != true
		upgrade.action = func(): State.rock_available = true
		
		list.append(upgrade)
	
	
	#for i in 3:
		#var upgrade: Upgrade = Upgrade.new()
		#
		#upgrade.title = "Even deadlier rock!"
		#upgrade.texture = ROCK_BIG
		#upgrade.mult = 1.4
		#upgrade.condition = func(): return State.rock_available
		#upgrade.action = func(): State.player_config.wave_width *= 1.4
		#
		#list.append(upgrade)
	
	
	for i in 3:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "More health!"
		upgrade.mult = 1.2
		upgrade.action = func(): State.player_config.max_health *= 1.2
		
		list.append(upgrade)
	
	for i in 3:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "More overall damage!"
		upgrade.mult = 1.1
		upgrade.action = func(): State.player_config.damage_mult *= 1.1
		
		list.append(upgrade)
	
	for i in 6:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "More Shadows!"
		upgrade.desctiption = "Allows you add one more copy of yourself"
		upgrade.action = func(): State.max_copies += 1
		
		list.append(upgrade)
	
	
	return list
	
