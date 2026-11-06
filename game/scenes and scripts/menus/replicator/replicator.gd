extends StaticBody3D

@export var replicate_time: float = 0.5

func interact(hud: CanvasLayer) -> void:
	hud.open_replicator_menu()
