class_name Hud
extends CanvasLayer

@onready var interaction_label = $InteractionUI/InteractionLabel
@onready var dismantle_progress_bar = $InteractionUI/DismantleProgress
@onready var interaction_ui = $InteractionUI

func _ready() -> void:
	hideui()

func showui(message: String, progress: float) -> void:
	interaction_ui.show()
	interaction_label.text = message
	dismantle_progress_bar.value = progress

func hideui() -> void:
	interaction_ui.hide()
	dismantle_progress_bar.value = 0.0
