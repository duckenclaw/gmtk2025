extends CanvasLayer
class_name GameOverScreen

const MAIN_MENU = preload("uid://ihpur1o3hacr")

func show_game_over():
	
	get_tree().paused = true
	
	show()
	await WaitUtil.wait(5.0)
	
