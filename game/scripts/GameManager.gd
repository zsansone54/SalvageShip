extends Node

var game_data: Dictionary 
var credits: int
var inventory_capacity: int
var inventory_used: int
var inventory: Array[int] = []

signal inventory_changed(used: int, capacity: int)
signal credits_changed(added_credits: int)

func _ready() -> void:
	game_data = GameData.data()
	
	credits = game_data["initial_values"]["starting_credits"]
	inventory_capacity = game_data["initial_values"]["starting_capacity"]
	inventory_used = 0

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
