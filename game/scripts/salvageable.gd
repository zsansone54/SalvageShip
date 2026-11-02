extends StaticBody3D

@export var dismantle_time: float = 1.5
func interact():
	queue_free()
