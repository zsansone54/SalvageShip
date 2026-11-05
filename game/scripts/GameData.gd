class_name GameData
extends RefCounted

static func data() -> Dictionary:
	return {
		"game_version": "0.1",
		
		"initial_values": {
			"starting_credits": 100,
			"starting_capacity": 10
		},
		
		"salvage_items": [
			{
				"display_name": "Test Crate",
				"credit_value": 25,
				"inventory_size": 1
			},
			{
				"display_name": "Test Orb",
				"credit_value": 40,
				"inventory_size": 2
			},
			
		]
	}
	
