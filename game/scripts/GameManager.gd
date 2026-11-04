extends Node

var game_data: Dictionary 
var credits: int
var inventory_capacity: int
var inventory_used: int


func _ready() -> void:
	game_data = GameData.data()
	
	credits = game_data["initial_values"]["starting_credits"]
	inventory_capacity = game_data["initial_values"]["starting_capacity"]
	inventory_used = 0

func _process(delta: float) -> void:
	pass
