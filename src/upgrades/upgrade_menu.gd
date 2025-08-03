extends CanvasLayer
class_name UpgradeMenu

const UPGRADE_CARD = preload("uid://4qenjsgkc0ts")

var all_upgrades: Array[Upgrade]

@onready var color_rect: ColorRect = $ColorRect
@onready var h_box_container: HBoxContainer = $CenterContainer/HBoxContainer

func _ready() -> void:
	all_upgrades = UpgradeList.get_upgrade_list()

func entrance():
	visible = true
	var selected_upgrades: Array[Upgrade] = select_new_upgrades()
	
	if selected_upgrades.is_empty():
		exit()
		return
	
	await WaitUtil.wait(0.4)
	
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
	var selected_upgrade_names: Array[String]
	for i in min(upgrades.size(), 3):
		var new_upgrade: Upgrade = upgrades.pick_random()
		
		for k in 10:
			if selected_upgrade_names.has(new_upgrade.title) or not available(new_upgrade):
				new_upgrade = upgrades.pick_random()
			else:
				break
		if selected_upgrade_names.has(new_upgrade.title) or not available(new_upgrade):
			continue
		
		upgrades.erase(new_upgrade)
		selected_upgrades.append(new_upgrade)
		selected_upgrade_names.append(new_upgrade.title)
	return selected_upgrades

func available(upgrade: Upgrade) -> bool:
	if upgrade.condition.is_valid():
		return upgrade.condition.call()
	else:
		return true
