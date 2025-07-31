extends Control

@export var start_scene: PackedScene = preload("res://src/map/game_map.tscn")

@onready var title_screen: MarginContainer = $TitleScreen
@onready var options_screen: MarginContainer = $OptionsScreen

func _on_start_button_pressed():
	print("start")
	get_tree().change_scene_to_packed(start_scene)
	
func _on_options_button_pressed():
	toggle_options()
	print("options")

func _on_exit_options_button_pressed():
	toggle_options()
	print("exit options")

func _on_exit_button_pressed():
	get_tree().quit()

func toggle_options():
	title_screen.visible = !title_screen.visible
	options_screen.visible = !options_screen.visible
