extends Node
class_name DialogueController

const RANDOM_PHRASE_MIN_TIME = 20_000 #msec
const RANDOM_PHRASE_MAX_TIME = 30_000 #msec

@onready var dialogue_panel: PanelContainer = $"../Hints/DialoguePanel"
@onready var label: Label = $"../Hints/DialoguePanel/MarginContainer/Label"

var message_queue: Array[String] # "" for pause
var spoken_messages: Array[String]
var speaking: bool = false

var last_speak_time: int = 1000000 # to not interrupt first line
var interval_for_next_random_phrase: int = 1000000
var fun_random_phrases: Array[Array] = [
	[
		"On days like this kids like you...",
		"...should be burning in hell"
	],
	[
		"_random_phrase_",
		"I'm joking, I wouldn't have forgotten something like this in the game"
	],
	[
		"Cool kids go to hell"
	],
	[
		"No refunds. No exits. No hope. Enjoy the ride."
	],
	[
		"Lost souls, please remain seated until we crash into oblivion."
	],
	[
		"Keep your limbs inside the vehicle at all times.",
		"They’re still technically yours."
	],
	[
		"Your screams are important to us. Please hold."
	],
	[
		"I used to drive demons and gargoyles too. ",
		"Some say they can give big bonuses and special abilities",
		"Maybe in the next update"
	],
	[
		"You guys ever notice how nobody tips the demon driver?",
		"Rude."
	]
]

func _ready():
	dialogue_panel.hide()
	
	#subscribe to signals here
	
	add_hello()

func _process(_delta: float):
	if Time.get_ticks_msec() - last_speak_time > interval_for_next_random_phrase:
		if fun_random_phrases.is_empty():
			return
		var phrase_array = fun_random_phrases.pick_random()
		if phrase_array == null:
			return 
		
		fun_random_phrases.erase(phrase_array)
		for message in phrase_array:
			add_message_to_queue(message)

func delay_speaking():
	last_speak_time = Time.get_ticks_msec()
	interval_for_next_random_phrase = Random.i_range(RANDOM_PHRASE_MIN_TIME, RANDOM_PHRASE_MAX_TIME)

func add_message_to_queue(message: String):
	if spoken_messages.has(message):
		# don't repeat yourself
		return
	
	delay_speaking()
	
	message_queue.append(message)
	if not speaking:
		speak_next_message()

func speak_next_message():
	var message = message_queue.pop_front()
	if message != null:
		await animate_message(message)

func animate_message(message: String):
	speaking = true
	
	if message == "":
		await WaitUtil.wait(1.7)
		speaking = false
		speak_next_message()
		return
	
	label.text = message
	dialogue_panel.show()
	await (create_tween()
		.tween_property(label, "visible_ratio", 1.0, message.length() * 0.02)
		.from(0.0)
		.finished)
	await WaitUtil.wait(1.7)
	dialogue_panel.hide()
	
	speaking = false
	speak_next_message()

func add_hello():
	add_message_to_queue("")
	add_message_to_queue("What’s up, sinners?")
	add_message_to_queue("Pack 'em in tight and let's go")
	add_message_to_queue("Press SPACE to rotate these poor guys")
	add_message_to_queue("You'll see how it works in a moment")

func add_counting_explanation():
	add_message_to_queue("Welcome to hell, baby!")
	add_message_to_queue("Every body needs to be accounted for")
	add_message_to_queue("Aaand you can squeeze some leftover soul if you combine them in a right way")
