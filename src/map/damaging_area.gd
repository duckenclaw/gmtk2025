extends Node2D

@export var target_group: String = "enemy"
@export var damage: float = 5.0

@onready var hitbox: Area2D = $Area2D


func _physics_process(_delta):
	for area in hitbox.get_overlapping_areas():
		if !area.is_invincible and area.is_in_group(target_group):
			area.take_damage(damage)

func _on_area_2d_body_entered(body):
	if body.is_in_group(target_group) and !body.is_invincible:
		body.take_damage(damage)


func _on_area_2d_area_entered(area):
	if area.is_in_group(target_group) and !area.is_invincible:
		area.take_damage(damage)
