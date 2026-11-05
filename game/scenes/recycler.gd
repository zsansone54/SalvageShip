extends StaticBody3D

@export var recycle_time: float = 0.5

func interact():
	GameManager.recycle_inventory()
