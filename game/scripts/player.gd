extends CharacterBody3D

var input_direction: Vector2
var speed: float = 5.0

@export var mouse_sensitivity: float = 0.005
@export var acceleration = 25.0
@export var jump_velocity = 4.5

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
		if event is InputEventMouseMotion and Input.mouse_mode  == Input.MOUSE_MODE_CAPTURED:
			head.rotate_y(-event.relative.x * mouse_sensitivity)
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

		if Input.is_action_just_pressed("pause"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		if event is InputEventMouseButton and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Gravity when in air
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get input diections
	input_direction = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	# Calculate movement
	var target_velocity = direction * speed
	var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
	
	if is_on_floor():
		if direction:
			horizontal_velocity = horizontal_velocity.move_toward(
				target_velocity,
				acceleration * delta
			)
		else:
			horizontal_velocity = horizontal_velocity.move_toward(
				Vector3.ZERO,
				acceleration * delta
			)

		velocity.x = horizontal_velocity.x
		velocity.z = horizontal_velocity.z
	move_and_slide()
