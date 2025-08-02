class_name UpgradeList

static func get_upgrade_list() -> Array[Upgrade]:
	var list: Array[Upgrade]
	
	var open_black_hole: Upgrade = Upgrade.new()
	
	open_black_hole.title = "New weapon - BLACK HOLE"
	open_black_hole.desctiption = "Deals small damage. Sucks enemies into the center"
	open_black_hole.action = func(): State.black_hole_available = true
	
	list.append(open_black_hole)
	
	
	for i in 3:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "More health!"
		upgrade.mult = 1.2
		upgrade.action = func(): State.player_config.max_health *= 1.2
		
		list.append(upgrade)
	
	for i in 3:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "More damage!"
		upgrade.mult = 1.1
		upgrade.action = func(): State.player_config.damage_mult *= 1.1
		
		list.append(upgrade)
	
	for i in 3:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "Wider black hole!"
		upgrade.mult = 1.4
		upgrade.condition = func(): return State.black_hole_available
		upgrade.action = func(): State.player_config.black_hole_radius *= 1.4
		
		list.append(upgrade)
	
	for i in 3:
		var upgrade: Upgrade = Upgrade.new()
		
		upgrade.title = "More fire damage!"
		upgrade.mult = 1.4
		upgrade.condition = func(): return State.fire_available
		upgrade.action = func(): State.player_config.fire_damage *= 1.4
		
		list.append(upgrade)
	
	return list
	
