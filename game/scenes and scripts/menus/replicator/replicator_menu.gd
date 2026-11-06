extends Control

@onready var slide_container = $CenterContainer
@onready var inventory_list = $CenterContainer/Panel/MarginContainer/VBoxContainer/InventoryList
@onready var total_value_label = $CenterContainer/Panel/MarginContainer/VBoxContainer/TotalValueLabel
@onready var recycle_all_button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonRow/RecycleAllButton
@onready var close_button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonRow/CloseButton


func _ready() -> void:
	hide()

	recycle_all_button.pressed.connect(_on_recycle_all_pressed)
	close_button.pressed.connect(close_menu)


func open_menu() -> void:
	populate_inventory_list()

	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	slide_container.slide_in()


func close_menu() -> void:
	var close_tween = slide_container.slide_out()
	await close_tween.finished

	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func populate_inventory_list() -> void:
	for child in inventory_list.get_children():
		child.queue_free()

	var item_counts: Dictionary = {}
	var total_value := 0

	for salvage_id in GameManager.inventory:
		item_counts[salvage_id] = item_counts.get(salvage_id, 0) + 1

	for salvage_id in item_counts:
		var item_data = GameManager.get_salvage_data(salvage_id)
		var quantity: int = item_counts[salvage_id]
		var item_value: int = item_data["credit_value"]

		total_value += item_value * quantity

		var item_label := Label.new()
		item_label.text = "%s x%d — %d Credits" % [
			item_data["display_name"],
			quantity,
			item_value * quantity
		]

		inventory_list.add_child(item_label)

	if item_counts.is_empty():
		var empty_label := Label.new()
		empty_label.text = "No salvage stored."
		inventory_list.add_child(empty_label)

	total_value_label.text = "Total Value: %d Credits" % total_value
	recycle_all_button.disabled = item_counts.is_empty()


func _on_recycle_all_pressed() -> void:
	GameManager.recycle_inventory()
	populate_inventory_list()
