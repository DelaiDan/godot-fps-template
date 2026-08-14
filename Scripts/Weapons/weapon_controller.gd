class_name WeaponController extends Node

@export var camera: Camera3D
@export var current_weapon: Weapon
@export var weapon_model_parent: Node3D
@export var weapon_state_chart: StateChart

var current_weapon_model: Node3D
var current_ammo: int

func _ready() -> void:
	if current_weapon:
		spawn_weapon_model();
		current_ammo = current_weapon.max_ammo


func spawn_weapon_model():
	if current_weapon_model:
		current_weapon_model.queue_free();
	
	if current_weapon.weapon_model:
		current_weapon_model = current_weapon.weapon_model.instantiate()
		weapon_model_parent.add_child(current_weapon_model)
		current_weapon_model.position = current_weapon.weapon_position


func can_fire() -> bool:
	return current_ammo > 0


func fire_weapon() -> void:
	if can_fire():
		current_ammo -= 1
		print("Fired! Ammo: ", current_ammo)
		
		if current_weapon.is_hitscan:
			current_weapon.perform_hitscan(camera, self)
		else:
			current_weapon.spawn_projectile(camera, self)
	
