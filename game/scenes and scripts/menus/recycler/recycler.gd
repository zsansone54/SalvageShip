extends StaticBody3D

@export var recycle_time: float = 0.5

func interact(hud: CanvasLayer) -> void:
	hud.open_recycler_menu()
