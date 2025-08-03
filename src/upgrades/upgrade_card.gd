extends PanelContainer
class_name UpgradeCard

signal finished

@export var upgrade: Upgrade


@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel



func _ready() -> void:
	title_label.text = upgrade.title
	texture_rect.texture = upgrade.texture
	
	if upgrade.mult != 1.0:
		description_label.text = "Multiplier: " + str(upgrade.mult)
	else:
		description_label.text = upgrade.desctiption
	

func _on_mouse_pressed_listener_mouse_pressed() -> void:
	upgrade.action.call()
	print(upgrade.title + " " + str(upgrade.mult))
	print(StringUtils.get_resource_properties_string(State.player_config))
	finished.emit()
