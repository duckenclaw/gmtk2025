extends Node
class_name Game

@onready var game_map: GameMap = $GameMap
@onready var game_ui: GameUi = $GameUi


func _ready() -> void:
	Ref.particle_layer = $ParticleLayer
	
	game_map.player.player_health_changed.connect(game_ui.player_health_changed)
	game_map.player.player_died
	
	game_map.flag.origin_health_changed.connect(game_ui.flag_health_changed)
