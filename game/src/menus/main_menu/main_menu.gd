extends Control


@onready var version_label: Label = $VersionLabel
@onready var settings_menu: Control = $SettingsMenu


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	version_label.text = "v%s" % GameData.data().get("game_version", "0.0.0")


func _on_start_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/game/game.tscn")


func _on_options_button_pressed() -> void:
	settings_menu.open_menu()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
