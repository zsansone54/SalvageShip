extends CanvasLayer

@onready var interaction_label = $InteractionUI/InteractionLabel
@onready var dismantle_progress_bar = $InteractionUI/DismantleProgress
@onready var interaction_ui = $InteractionUI
@onready var credits_label = $TopHud/CreditsLabel
@onready var capacity_label = $TopHud/CapacityLabel
@onready var recycler_menu = $RecyclerMenu
@onready var replicator_menu = $ReplicatorMenu

func _ready() -> void:
	hideui()
	update_inventory(GameManager.inventory_used, GameManager.inventory_capacity)
	update_credits(GameManager.credits)
	GameManager.inventory_changed.connect(update_inventory)
	GameManager.credits_changed.connect(update_credits)

func showui(message: String, progress: float) -> void:
	interaction_ui.show()
	interaction_label.text = message
	dismantle_progress_bar.value = progress

func hideui() -> void:
	interaction_ui.hide()
	dismantle_progress_bar.value = 0.0

func update_inventory(used: int, capacity: int) -> void:
	capacity_label.text = "Salvage: %d / %d" % [used, capacity]

func update_credits(current_credits: int) -> void:
	credits_label.text = "C: %d" % [current_credits]

func open_recycler_menu() -> void:
	hideui()
	recycler_menu.open_menu()

func open_replicator_menu() -> void:
	hideui()
	replicator_menu.open_menu()

func is_menu_open() -> bool:
	return recycler_menu.visible
