extends Node


var game_data: Dictionary
var credits: int
var inventory_capacity: int
var inventory_used: int
var inventory: Array[int] = []
var upgrade_levels: Array[int] = []

var mouse_sensitivity: float = 0.005

signal inventory_changed(used: int, capacity: int)
signal credits_changed(current_credits: int)
signal upgrade_purchased(upgrade_id: int, new_level: int)
signal mouse_sensitivity_changed(new_sensitivity: float)


func _ready() -> void:
	game_data = GameData.data()

	credits = game_data["initial_values"]["starting_credits"]
	inventory_capacity = game_data["initial_values"]["starting_capacity"]
	inventory_used = 0

	for upgrade in game_data["upgrades"]:
		upgrade_levels.append(0)


func get_salvage_data(salvage_id: int) -> Dictionary:
	var salvage_items = game_data["salvage_items"]
	var data := {}

	if salvage_id >= 0 and salvage_id < salvage_items.size():
		data = salvage_items[salvage_id]

	return data


func try_add_salvage(salvage_id: int) -> bool:
	var salvage_data = get_salvage_data(salvage_id)

	if salvage_data.is_empty():
		return false

	var item_size: int = salvage_data["inventory_size"]

	if item_size + inventory_used > inventory_capacity:
		return false

	inventory.append(salvage_id)
	inventory_used += item_size
	inventory_changed.emit(inventory_used, inventory_capacity)
	return true


func recycle_inventory() -> void:
	for salvage_id in inventory:
		credits += get_salvage_data(salvage_id)["credit_value"]

	inventory.clear()
	inventory_used = 0

	credits_changed.emit(credits)
	inventory_changed.emit(inventory_used, inventory_capacity)


func try_purchase_upgrade(upgrade_id: int) -> bool:
	var upgrades = game_data["upgrades"]

	if upgrade_id < 0 or upgrade_id >= upgrades.size():
		return false

	var upgrade_data = upgrades[upgrade_id]
	var upgrade_costs = upgrade_data["costs"]
	var current_level: int = upgrade_levels[upgrade_id]

	if current_level >= upgrade_costs.size():
		return false

	var cost: int = upgrade_costs[current_level]

	if credits < cost:
		return false

	credits -= cost
	upgrade_levels[upgrade_id] += 1
	inventory_capacity += upgrade_data["capacity_per_level"]

	credits_changed.emit(credits)
	inventory_changed.emit(inventory_used, inventory_capacity)
	upgrade_purchased.emit(upgrade_id, upgrade_levels[upgrade_id])

	return true


func set_mouse_sensitivity(new_sensitivity: float) -> void:
	mouse_sensitivity = clampf(new_sensitivity, 0.001, 0.020)
	mouse_sensitivity_changed.emit(mouse_sensitivity)
