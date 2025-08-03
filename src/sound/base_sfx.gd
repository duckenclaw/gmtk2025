extends AudioStreamPlayer
class_name BaseSfx


func _ready():
	play()
	bus = "Effects"
	finished.connect(on_finished_playing)

func on_finished_playing():
	queue_free()
