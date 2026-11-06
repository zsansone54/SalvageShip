extends Control


@onready var slide_container: Control = $CenterContainer
@onready var resume_button: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonRow/ResumeButton
@onready var options_button: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonRow/OptionsButton
@onready var return_to_menu_button: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/ButtonRow/ReturnToMenuButton
@onready var settings_menu: Control = $SettingsMenu

var is_closing := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

	resume_button.pressed.connect(close_menu)
	options_button.pressed.connect(_on_options_button_pressed)
	return_to_menu_button.pressed.connect(_on_return_to_menu_button_pressed)


func open_menu() -> void:
	if visible:
		return

	show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	slide_container.slide_in()


func close_menu() -> void:
	if not visible or is_closing:
		return

	is_closing = true

	var close_tween = slide_container.slide_out()
	await close_tween.finished

	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	is_closing = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not settings_menu.visible:
		close_menu()
		get_viewport().set_input_as_handled()


func _on_options_button_pressed() -> void:
	settings_menu.open_menu()


func _on_return_to_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/menus/main_menu/MainMenu.tscn")
