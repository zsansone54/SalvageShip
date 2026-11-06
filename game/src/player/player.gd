extends CharacterBody3D

var input_direction: Vector2
var speed: float = 5.0
var hold_target: Node = null
var hold_progress: float = 0.0

@export var mouse_sensitivity: float = 0.005
@export var acceleration = 25.0
@export var jump_velocity = 4.5

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interaction_raycast = $Head/Camera3D/InteractionRaycast
@onready var hud = $Hud

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hud.hideui()

func _unhandled_input(event):
		if hud.is_menu_open():
			return
		if event is InputEventMouseMotion and Input.mouse_mode  == Input.MOUSE_MODE_CAPTURED:
			head.rotate_y(-event.relative.x * mouse_sensitivity)
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

		if Input.is_action_just_pressed("pause"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		if event is InputEventMouseButton and event.pressed:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if hud.is_menu_open():
		return
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

	if interaction_raycast.is_colliding():
		var aimed_target := interaction_raycast.get_collider() as Node

		if aimed_target != null \
		and aimed_target.has_method("interact"):
			var interaction_message: String
			if aimed_target.is_in_group("salvageable") :
				
				
				if aimed_target.is_in_group("pickupable"):
					interaction_message = "Hold E to pick up"
				else:
					interaction_message = "Hold E to dismantle"
					
				if aimed_target != hold_target:
					hold_target = aimed_target
					hold_progress = 0.0
					
				var dismantle_time: float = hold_target.get("dismantle_time")

				if Input.is_action_pressed("interact"):
					hold_progress += delta
				else:
					hold_progress = 0.0

				var progress_percent := (hold_progress / dismantle_time) * 100.0
				hud.showui(interaction_message, progress_percent)

				if hold_progress >= dismantle_time:
					var completed_target := hold_target
					hold_target = null
					hold_progress = 0.0
					var was_salvaged: bool = completed_target.call("interact")
					if was_salvaged:
						hud.hideui()
				
			elif aimed_target.is_in_group("recycler"):
				if aimed_target != hold_target:
					hold_target = aimed_target
					hold_progress = 0.0

				var recycle_time: float = aimed_target.get("recycle_time")

				if Input.is_action_pressed("interact"):
					hold_progress += delta
				else:
					hold_progress = 0.0

				var progress_percent := (hold_progress / recycle_time) * 100.0
				hud.showui("Hold E to recycle salvage", progress_percent)

				if hold_progress >= recycle_time:
					var completed_target := hold_target

					hold_target = null
					hold_progress = 0.0
					hud.hideui()

					completed_target.call("interact", hud)
					
			elif aimed_target.is_in_group("replicator"):
				if aimed_target != hold_target:
					hold_target = aimed_target
					hold_progress = 0.0

				var replicate_time: float = aimed_target.get("replicate_time")

				if Input.is_action_pressed("interact"):
					hold_progress += delta
				else:
					hold_progress = 0.0

				var progress_percent := (hold_progress / replicate_time) * 100.0
				hud.showui("Hold E to purchase upgrades", progress_percent)

				if hold_progress >= replicate_time:
					var completed_target := hold_target

					hold_target = null
					hold_progress = 0.0
					hud.hideui()

					completed_target.call("interact", hud)
		else:
			hud.hideui()
			hold_target = null
			hold_progress = 0.0
	else:
		hud.hideui()
		hold_target = null
		hold_progress = 0.0
