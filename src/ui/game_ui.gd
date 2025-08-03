extends CanvasLayer
class_name GameUi

const ACTION_BUTTON = preload("uid://cig20fddjdm1r")
const COPY_BUTTON = preload("uid://c28sw4vsxpqlj")


signal action_selected()
signal create_copy_pressed

@onready var flag_progress_bar: ProgressBar = $HealthContainer/FlagProgressBar
@onready var player_progress_bar: ProgressBar = $HealthContainer/PlayerProgressBar
@onready var create_copy_button: Button = $CreateCopyButton
@onready var time_label: Label = $TimeLabel
@onready var exp_progress_bar: ProgressBar = $ExpContainer/ProgressBar

@onready var copies_container: BoxContainer = $CopiesCenterContainer/Copies

@onready var actions_container: HBoxContainer = $Actions



func _ready() -> void:
	player_progress_bar.value = State.player_config.max_health
	flag_progress_bar.value = State.flag_max_health


func _process(_delta: float) -> void:
	update_health_bars()
	update_exp_bar()
	
	time_label.text = str(int(State.LOOP_TIME - State.loop_progress_sec + 1))
	
	setup_copies()
	setup_actions()

func update_exp_bar():
	exp_progress_bar.max_value = State.exp_to_next_lvl
	exp_progress_bar.value = State.exp

func update_health_bars():
	player_progress_bar.max_value = State.player_config.max_health
	flag_progress_bar.max_value = State.flag_max_health

func setup_actions():
	var action_buttons := actions_container.get_children()
	for i in action_buttons.size():
		var button: ActionButton = action_buttons[i]
		button.action_index = i
		button.is_available = Action.get_action_enabled(i)
		button.is_pending = i == State.pending_selected_action_index
		button.is_active = i == State.selected_action_index
		

func setup_copies():
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
		copies_container.add_child(copy_button)
		

func player_health_changed(health: float):
	player_progress_bar.value = health
	

func flag_health_changed(health: float):
	flag_progress_bar.value = health


func _on_create_copy_button_pressed() -> void:
	create_copy_pressed.emit()
