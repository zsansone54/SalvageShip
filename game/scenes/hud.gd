class_name Hud
extends Control

@onready var interaction_label = $HUD/InteractionUI/InteractionLabel
@onready var dismantle_progress_bar = $HUD/InteractionUI/DismantleProgress
@onready var interaction_ui = $HUD/InteractionUI


func showui():
	interaction_ui.show()

func hideui():
	interaction_ui.hide()
