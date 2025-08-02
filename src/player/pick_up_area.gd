extends Area2D
class_name PickUpArea

var collectables: Array[Node2D]

func _process(delta: float) -> void:
	for thing in collectables:
		var distance = global_position.distance_to(thing.global_position) + 10.0
		thing.global_position = lerp(thing.global_position, global_position, 500 * delta / distance)

func collect(area: Area2D):
	area.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("collectable"):
		collectables.append(area)


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("collectable"):
		collectables.erase(area)


func _on_player_area_entered(area: Area2D) -> void:
	if area.is_in_group("collectable"):
		collect(area)
