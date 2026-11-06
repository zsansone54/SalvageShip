extends StaticBody3D

@export var dismantle_time: float = 1.5
@export var salvage_id: int = 0

func interact() -> bool:
	var add_salvage = GameManager.try_add_salvage(salvage_id)
	if add_salvage:
		queue_free()
	return add_salvage
