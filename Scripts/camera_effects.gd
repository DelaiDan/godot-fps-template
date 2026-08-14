class_name CameraEffects extends Camera3D

@export_category("References")
@export var player: PlayerController

@export_category("Effects")
@export var enable_tilt: bool = true
@export var enable_fall_kick: bool = true
@export var enable_damage_kick: bool = true

@export_category("Kick & Recoil Settings")
@export_group("Run Tilt")
@export var run_pitch: float = 0.1
@export var run_roll: float = 0.2
@export var max_pitch: float = 1.0
@export var max_roll: float = 2.5

@export_group("Camera Kick")
@export_subgroup("Fail Kick")
@export var fall_time: float = 0.3
@export_subgroup("Damage Kick")
@export var damage_time: float = 0.3

var _fall_value: float = 0.0
var _fall_timer: float = 0.0

var _damage_pitch: float = 0.0
var _damage_roll: float = 0.0
var _damage_timer: float = 0.0


func _process(delta: float) -> void:
	calculate_view_offset(delta)

func calculate_view_offset(delta):
	if not player:
		return
	
	_fall_timer -= delta
	_damage_timer -= delta
	
	var velocity = player.velocity
	
	var angles = Vector3.ZERO
	var offset = Vector3.ZERO
	
	if enable_tilt:
		var forward = global_transform.basis.z
		var right = global_transform.basis.x
		
		var forward_dot = velocity.dot(forward)
		var forward_tilt = clampf(forward_dot * deg_to_rad(run_pitch), deg_to_rad(-max_pitch), deg_to_rad(max_pitch))
		angles.x += forward_tilt
		
		var right_dot = velocity.dot(right)
		var side_tilt = clampf(right_dot * deg_to_rad(run_roll), deg_to_rad(-max_roll), deg_to_rad(max_roll))
		angles.z -= side_tilt
	
	if enable_fall_kick:
		var fall_ratio = max(0.0, _fall_timer / fall_time)
		var fall_kick_amount = fall_ratio * _fall_value
		
		angles.x -= fall_kick_amount
		offset.y -= fall_kick_amount

	if enable_damage_kick:
		var damage_ratio = max(0.0, _damage_timer / damage_time)
		# damage_ratio = ease(damage_ratio, -2) #ease
		angles.x += damage_ratio + _damage_pitch
		angles.z += damage_ratio + _damage_roll

	rotation = angles
	position = offset

func add_fall_kick(fall_strength: float):
	_fall_value = deg_to_rad(fall_strength)
	_fall_timer = fall_time
	
func add_damage_kick(pitch: float, roll: float, source: Vector3):
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	var direction = global_position.direction_to(source)
	
	var forward_dot = direction.dot(forward)
	var right_dot = direction.dot(right)

	_damage_pitch = deg_to_rad(pitch) * forward_dot
	_damage_roll = deg_to_rad(roll) * right_dot
	_damage_timer = damage_time
	
