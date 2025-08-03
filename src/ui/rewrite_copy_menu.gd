extends CanvasLayer
class_name RewriteCopyMenu

const COPY_BUTTON = preload("uid://c28sw4vsxpqlj")

@export var recorder: RecorderArea

@onready var label: Label = $CenterContainer2/VBoxContainer/Label
@onready var hint_label: Label = $CenterContainer2/VBoxContainer/HintLabel
@onready var copies_container: HBoxContainer = $CopiesCenterContainer/Copies

var saved_player: Player

func open_remove_copy_on_death(player: Player):
	show()
	saved_player = player
	label.text = "YOU DIED. TAKE PLACE OF YOUR SHADOW"
	hint_label.text = "You will take it's place the start of a new cycle"
	
	await WaitUtil.wait(0.4)
	setup_copies(remove_copy_on_death)

func remove_copy_on_death(copy_button: CopyButton):
	recorder.remove_recording(copy_button.record, copy_button.copy)
	State.max_copies -= 1
	exit()


func open_rewrite_copy(player: Player):
	saved_player = player
	show()
	label.text = "SELECT A SHADOW TO REWRITE"
	hint_label.text = "Upgrades are applied only to you and your NEW shadows! Replace your old shadows to be more effective"
	
	await WaitUtil.wait(0.4)
	setup_copies(rewrite_copy)


func rewrite_copy(copy_button: CopyButton):
	recorder.remove_recording(copy_button.record, copy_button.copy)
	State.all_time_copies += 1
	recorder.save_recording(saved_player, State.all_time_copies)
	exit()

func setup_copies(click_callable: Callable):
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
		
		copy_button.clicked.connect(click_callable.bind(copy_button))
		
		copies_container.add_child(copy_button)

func exit():
	visible = false
	NodeUtils.queue_free_children(copies_container)
	get_tree().paused = false
