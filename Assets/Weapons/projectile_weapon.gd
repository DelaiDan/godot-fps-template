class_name ProjectileWeapon extends Weapon

var is_hitscan = false
@export var projectile_scene: PackedScene
@export var projectile_range: float = 25.0
@export var projectile_speed: float = 50.0

func spawn_projectile(camera: Camera3D, weapon: WeaponController) -> void:
	if not projectile_scene:
		print("No projectile scene assigned!")
		return
	
	if not camera:
		print("No camera assigned!")
		return
	
	var projectile = projectile_scene.instantiate() as BaseProjectile
	weapon.get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = camera.global_position
	
	var forward = -camera.global_transform.basis.z
	var velocity = forward * projectile_speed
	projectile.look_at(projectile.global_position + forward, Vector3.UP)
	
	projectile.setup(velocity, damage)
	
