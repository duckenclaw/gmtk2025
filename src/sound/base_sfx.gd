extends AudioStreamPlayer
class_name BaseSfx


func _ready():
	play()
	bus = "Effects"
	if OS.get_name() == "WEB":
		volume_db = -17
	finished.connect(on_finished_playing)

func on_finished_playing():
	queue_free()
