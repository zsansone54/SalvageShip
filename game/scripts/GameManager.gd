extends Node

var game_data: Dictionary 
var credits: int
var inventory_capacity: int
var inventory_used: int


func _ready() -> void:
	game_data = GameData.data()


func _process(delta: float) -> void:
	pass
