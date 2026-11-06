extends Control

@export var hidden_offset_y: float = 700.0
@export var slide_duration: float = 0.25

var open_position: Vector2
var closed_position: Vector2
var current_tween: Tween


func _ready() -> void:
	open_position = position
	closed_position = open_position + Vector2(0, hidden_offset_y)
	position = closed_position


func slide_in() -> void:
	if current_tween:
		current_tween.kill()

	position = closed_position
	current_tween = create_tween()
	current_tween.tween_property(
		self,
		"position",
		open_position,
		slide_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func slide_out() -> Tween:
	if current_tween:
		current_tween.kill()

	current_tween = create_tween()
	current_tween.tween_property(
		self,
		"position",
		closed_position,
		slide_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	return current_tween
