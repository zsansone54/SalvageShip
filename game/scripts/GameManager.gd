extends Node

var game_data: Dictionary 
var credits: int
var inventory_capacity: int
var inventory_used: int
var inventory: Array[int] = []
var upgrade_levels: Array[int] = []

signal inventory_changed(used: int, capacity: int)
signal credits_changed(current_credits: int)
signal upgrade_purchased(upgrade_id: int, new_level: int)

func _ready() -> void:
	game_data = GameData.data()
	
	credits = game_data["initial_values"]["starting_credits"]
	inventory_capacity = game_data["initial_values"]["starting_capacity"]
	inventory_used = 0
	upgrade_levels = [0]

func get_salvage_data(salvage_id: int) -> Dictionary:
	var salvage_items = game_data["salvage_items"]
	var data = {}
	
	if salvage_id >= 0 and salvage_id < salvage_items.size():
		data = salvage_items[salvage_id]
	
	return data

func try_add_salvage(salvage_id: int) -> bool:
	var salvage_data = get_salvage_data(salvage_id)
	if salvage_data.size() == 0:
		return false
	else:
		var size = salvage_data["inventory_size"]
		if (size + inventory_used) > inventory_capacity:
			return false
		else:
			inventory.append(salvage_id)
			inventory_used += size
			inventory_changed.emit(inventory_used, inventory_capacity)
			return true

func recycle_inventory() -> void:
	for id in inventory:
		credits += get_salvage_data(id)["credit_value"]
	inventory = []
	inventory_used = 0
	credits_changed.emit(credits)
	inventory_changed.emit(inventory_used, inventory_capacity)

func try_purchase_upgrade(upgrade_id: int) -> bool:
	var upgrades = game_data["upgrades"]
	if upgrade_id >= 0 and upgrade_id < upgrades.size():
		var upgrade_costs = upgrades[upgrade_id]["costs"]
		if upgrade_id < upgrade_costs.size():
			var cost = upgrade_costs[upgrade_id]
			if credits >= cost:
				credits -= cost
				upgrade_levels[upgrade_id] += 1
				if upgrade_id == 0:
					inventory_capacity += upgrades[upgrade_id]["capacity_per_level"]
					credits_changed.emit(credits)
					inventory_changed.emit(inventory_used, inventory_capacity)
					upgrade_purchased.emit(upgrade_id, upgrade_levels[upgrade_id])
					return true
				else:
					return false
			else:
				return false
		else:
			return false
	else:
		return false
