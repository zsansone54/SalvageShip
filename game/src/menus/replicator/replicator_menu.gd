extends Control


@onready var slide_container = $CenterContainer
@onready var credits_label = $CenterContainer/Panel/MarginContainer/VBoxContainer/CreditsLabel
@onready var upgrade_purchase_list = $CenterContainer/Panel/MarginContainer/VBoxContainer/UpgradePurchaseList
@onready var close_button = $CenterContainer/Panel/MarginContainer/VBoxContainer/CloseButton


func _ready() -> void:
	hide()

	close_button.pressed.connect(close_menu)
	GameManager.credits_changed.connect(_on_credits_changed)
	GameManager.upgrade_purchased.connect(_on_upgrade_purchased)


func open_menu() -> void:
	refresh_menu()

	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	slide_container.slide_in()


func close_menu() -> void:
	var close_tween = slide_container.slide_out()
	await close_tween.finished

	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func refresh_menu() -> void:
	credits_label.text = "Credits: %d" % GameManager.credits

	for child in upgrade_purchase_list.get_children():
		child.queue_free()

	var upgrades = GameManager.game_data["upgrades"]

	for upgrade_id in upgrades.size():
		var upgrade_data = upgrades[upgrade_id]
		var current_level: int = GameManager.upgrade_levels[upgrade_id]
		var max_level: int = upgrade_data["costs"].size()

		var upgrade_row := VBoxContainer.new()
		upgrade_purchase_list.add_child(upgrade_row)

		var name_label := Label.new()
		name_label.text = upgrade_data["display_name"]
		name_label.add_theme_font_size_override("font_size", 26)
		upgrade_row.add_child(name_label)

		var details_row := HBoxContainer.new()
		upgrade_row.add_child(details_row)

		var level_label := Label.new()
		level_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		level_label.text = "Level %d / %d   (+%d Capacity per level)" % [
			current_level,
			max_level,
			upgrade_data["capacity_per_level"]
		]
		details_row.add_child(level_label)

		var purchase_button := Button.new()
		purchase_button.custom_minimum_size = Vector2(180, 45)
		details_row.add_child(purchase_button)

		if current_level >= max_level:
			purchase_button.text = "Max Level"
			purchase_button.disabled = true
		else:
			var next_cost: int = upgrade_data["costs"][current_level]
			purchase_button.text = "%d Credits" % next_cost
			purchase_button.disabled = GameManager.credits < next_cost
			purchase_button.pressed.connect(_on_purchase_button_pressed.bind(upgrade_id))


func _on_purchase_button_pressed(upgrade_id: int) -> void:
	GameManager.try_purchase_upgrade(upgrade_id)
	refresh_menu()


func _on_credits_changed(_current_credits: int) -> void:
	if visible:
		refresh_menu()


func _on_upgrade_purchased(_upgrade_id: int, _new_level: int) -> void:
	if visible:
		refresh_menu()
