extends CanvasLayer

@onready var interaction_label = $InteractionUI/InteractionLabel
@onready var dismantle_progress_bar = $InteractionUI/DismantleProgress
@onready var interaction_ui = $InteractionUI
@onready var credits_label = $TopHud/CreditsLabel
@onready var capacity_label = $TopHud/CapacityLabel

func _ready() -> void:
	hideui()
	update_inventory(GameManager.inventory_used, GameManager.inventory_capacity)
	GameManager.inventory_changed.connect(update_inventory)

func showui(message: String, progress: float) -> void:
	interaction_ui.show()
	interaction_label.text = message
	dismantle_progress_bar.value = progress

func hideui() -> void:
	interaction_ui.hide()
	dismantle_progress_bar.value = 0.0

func update_inventory(used: int, capacity: int) -> void:
	capacity_label.text = "Salvage: %d / %d" % [used, capacity]
