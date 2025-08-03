extends Node
# SOUND

var player: AudioStreamPlayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	player = AudioStreamPlayer.new()
	add_child(player)
	
	player.bus = "Music"
	start_soundtrack()

func play_fire():
	play_sfx("res://assets/sfx/slap.mp3")

func play_laser():
	play_sfx("res://assets/sfx/light.mp3")

func play_water():
	play_sfx("res://assets/sfx/splash.mp3")

func start_soundtrack():
	player.stream = load("res://assets/sfx/asian_soundtrack.mp3")
	player.play()

func play_sfx(sfx_res: String):
	var sfx = BaseSfx.new()
	sfx.stream = load(sfx_res)
	add_child(sfx)
