extends Action
class_name FireAction

const FIRE_DAMAGE = 1.0

@onready var area_2d: Area2D = $Area2D

var target_group: String = "enemy"
var targets_in_area: Array


func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.area_exited.connect(_on_area_exited)

func accept_command(command: Command):
	if command is CommandMouse:
		if command.is_pressed:
			for enemy in targets_in_area:
				enemy.take_damage(FIRE_DAMAGE)



func _on_area_entered(area):
	if area.is_in_group(target_group):
		targets_in_area.append(area)

func _on_area_exited(area):
	targets_in_area.erase(area)
