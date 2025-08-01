extends Action
class_name FireAction

const FIRE_DAMAGE: float = 1.0
const DAMAGE_TIMEOUT: float = 150 # msec

@onready var area_2d: Area2D = $Area2D

var target_group: String = "enemy"
var targets_in_area: Array

var last_damage_time: float = 0.0


func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)

func accept_command(command: Command):
	if command is CommandMouse:
		area_2d.rotation = command.direction.angle()
		
		area_2d.visible = command.is_pressed
		if Time.get_ticks_msec() - last_damage_time < DAMAGE_TIMEOUT: return
		
		if command.is_pressed:
			for enemy in targets_in_area:
				enemy.take_damage(FIRE_DAMAGE)



func _on_area_entered(area):
	if area.is_in_group(target_group):
		targets_in_area.append(area)

func _on_area_exited(area):
	targets_in_area.erase(area)
