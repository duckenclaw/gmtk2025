extends Node
# SOUND

const MIN_TIME_TO_REPLAY: float = 700.0

var recently_played: Dictionary # path to float: time

var player: AudioStreamPlayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	player = AudioStreamPlayer.new()
	
	if OS.get_name() == "WEB":
		player.volume_db = -10
	
	add_child(player)
	
	player.bus = "Music"

func _process(delta: float) -> void:
	var new_recently_played: Dictionary
	for path in recently_played:
		if Time.get_ticks_msec() - recently_played[path] < MIN_TIME_TO_REPLAY:
			new_recently_played[path] = recently_played[path]
	recently_played = new_recently_played

func play_fire():
	play_sfx("res://assets/sfx/fire.mp3")
	
func play_rock():
	play_sfx("res://assets/sfx/rock.mp3")
	
func play_black_hole():
	play_sfx("res://assets/sfx/black_hole.mp3")

func play_laser():
	play_sfx("res://assets/sfx/light.mp3")

func play_water():
	play_sfx("res://assets/sfx/splash.mp3")

func start_soundtrack():
	player.stream = load("res://assets/sfx/asian_soundtrack.mp3")
	player.play()

func play_sfx(sfx_res: String):
	if recently_played.has(sfx_res):
		return
	recently_played[sfx_res] = Time.get_ticks_msec()
	
	var sfx = BaseSfx.new()
	sfx.stream = load(sfx_res)
	add_child(sfx)
