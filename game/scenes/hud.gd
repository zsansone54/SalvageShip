class_name Hud
extends Control

@onready var interaction_label = $HUD/InteractionUI/InteractionLabel
@onready var dismantle_progress_bar = $HUD/InteractionUI/DismantleProgress
@onready var interaction_ui = $HUD/InteractionUI

func _ready() -> void:
	hideui()

func showui(message: String, progress: float) -> void:
	interaction_ui.show()
	interaction_label.text = message
	dismantle_progress_bar.value = progress

func hideui() -> void:
	interaction_ui.hide()
	dismantle_progress_bar.value = 0.0
