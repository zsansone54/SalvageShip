extends Control


@onready var sensitivity_label: Label = $CenterContainer/Panel/MarginContainer/VBoxContainer/MouseSensitivityLabel
@onready var sensitivity_slider: HSlider = $CenterContainer/Panel/MarginContainer/VBoxContainer/MouseSensitivitySlider
@onready var back_button: Button = $CenterContainer/Panel/MarginContainer/VBoxContainer/BackButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

	sensitivity_slider.value_changed.connect(_on_sensitivity_slider_value_changed)
	back_button.pressed.connect(close_menu)


func open_menu() -> void:
	sensitivity_slider.set_value_no_signal(GameManager.mouse_sensitivity)
	update_sensitivity_label(GameManager.mouse_sensitivity)

	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func close_menu() -> void:
	hide()


func _on_sensitivity_slider_value_changed(value: float) -> void:
	GameManager.set_mouse_sensitivity(value)
	update_sensitivity_label(value)


func update_sensitivity_label(value: float) -> void:
	sensitivity_label.text = "Mouse Sensitivity: %.3f" % value
