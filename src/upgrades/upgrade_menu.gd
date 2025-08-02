extends CanvasLayer
class_name UpgradeMenu

const UPGRADE_CARD = preload("uid://4qenjsgkc0ts")

var all_upgrades: Array[Upgrade]

@onready var color_rect: ColorRect = $ColorRect
@onready var h_box_container: HBoxContainer = $HBoxContainer


func _ready() -> void:
	all_upgrades = UpgradeList.get_upgrade_list()

func entrance():
	visible = true
	var selected_upgrades: Array[Upgrade] = select_new_upgrades()
	for upgrade in selected_upgrades:
		var card = UPGRADE_CARD.instantiate()
		card.upgrade = upgrade
		card.finished.connect(on_card_clicked.bind(card))
		h_box_container.add_child(card)

func on_card_clicked(card: UpgradeCard):
	all_upgrades.erase(card.upgrade)
	print("Removed from the list: " + card.upgrade.title)
	exit()

func exit():
	visible = false
	NodeUtils.queue_free_children(h_box_container)
	get_tree().paused = false

func select_new_upgrades() -> Array[Upgrade]:
	var upgrades = all_upgrades.duplicate()
	
	var selected_upgrades: Array[Upgrade]
	for i in min(upgrades.size(), 3):
		var new_upgrade = upgrades.pick_random()
		upgrades.erase(new_upgrade)
		selected_upgrades.append(new_upgrade)
	return selected_upgrades
