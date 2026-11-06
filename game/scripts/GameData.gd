class_name GameData
extends RefCounted

static func data() -> Dictionary:
	return {
		"game_version": "0.1",
		
		"initial_values": {
			"starting_credits": 50,
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
			
		],
		"upgrades": [
			{
				"display_name": "Cargo Expansion",
				"costs": [100, 250, 500],
				"capacity_per_level": 5
			}
		]
	}
	
