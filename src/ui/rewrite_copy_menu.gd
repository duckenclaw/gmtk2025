extends CanvasLayer
class_name RewriteCopyMenu

const COPY_BUTTON = preload("uid://c28sw4vsxpqlj")

@export var recorder: RecorderArea

@onready var label: Label = $CenterContainer2/VBoxContainer/Label
@onready var hint_label: Label = $CenterContainer2/VBoxContainer/HintLabel
@onready var copies_container: HBoxContainer = $CopiesCenterContainer/Copies

func remove_copy_on_death(player: Player):
	label.text = "YOU DIED. TAKE PLACE OF YOUR SHADOW"
	hint_label.text = "You will take it's place on a new cycle"
	
	await WaitUtil.wait(0.4)
	


func rewrite_copy(player: Player):
	show()
	label.text = "SELECT A SHADOW TO REWRITE"
	
	await WaitUtil.wait(0.4)
	
	setup_copies()
	
	#State.all_time_copies += 1
	#recorder.save_recording(player, State.all_time_copies)

func setup_copies():
	show()
	NodeUtils.queue_free_children(copies_container)
	for i in State.max_copies:
		var copy: Player
		var record: Record 
		if i < State.records.size():
			record = State.records.get(i)
		if record != null:
			copy = State.copies.get(record.id)
		
		var copy_button: CopyButton = COPY_BUTTON.instantiate()
		copy_button.record = record
		copy_button.copy = copy
		
		copy_button.clicked.connect(on_copy_button_clicked.bind(copy_button))
		
		copies_container.add_child(copy_button)

func on_copy_button_clicked(copy_button: CopyButton):
	exit()

func exit():
	visible = false
	NodeUtils.queue_free_children(copies_container)
	get_tree().paused = false
