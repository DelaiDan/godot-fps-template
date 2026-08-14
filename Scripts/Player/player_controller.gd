class_name PlayerController extends CharacterBody3D

@export var debug: bool = false;

@export_category("References")
@export var camera: CameraController
@export var camera_effects: CameraEffects
@export var state_chart: StateChart
@export var standing_collision: CollisionShape3D
@export var crouching_collision: CollisionShape3D
@export var crouch_check: ShapeCast3D
@export var interaction_raycast: RayCast3D

@export_category('Speed')
@export var default_speed: float = 5.0
@export var sprint_speed: float = 5.0
@export var crouch_speed: float = -2.0

@export_category("Jump Settings")
@export var jump_velocity: float = 5.0
@export var fall_velocity_threshold: float = -5.0

var speed: float = 0.0
var sprint_modifier: float = 0.0
var crouch_modifier: float = 0.0
var current_fall_velocity: float

var _input_dir: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var speed_modifier = sprint_modifier + crouch_modifier
	speed = default_speed + speed_modifier

	# # Handle jump.
	# if Input.is_action_just_pressed("move_jump") and is_on_floor():
	# 	velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	_input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var direction := (transform.basis * Vector3(_input_dir.x, 0, _input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func update_rotation(rotation_input) -> void:
	global_transform.basis = Basis.from_euler(rotation_input)

func sprint() -> void:
	sprint_modifier = sprint_speed

func walk() -> void:
	sprint_modifier = 0.0

func crouch() -> void:
	crouch_modifier = crouch_speed;
	crouching_collision.disabled = false;
	standing_collision.disabled = true;

func stand() -> void:
	crouch_modifier = 0.0;
	standing_collision.disabled = false;
	crouching_collision.disabled = true;

func jump() -> void:
	velocity.y += jump_velocity

func check_fall_speed() -> bool:
	if current_fall_velocity < fall_velocity_threshold:
		current_fall_velocity = 0.0
		return true
	else:
		current_fall_velocity = 0.0
		return false
