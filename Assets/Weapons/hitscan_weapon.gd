class_name HitscanWeapon extends Weapon

var is_hitscan = true
@export var projectile_range: float = 1000.0 #Huge range

func perform_hitscan(camera: Camera3D, weapon: WeaponController) -> void:
	if not camera:
		print("No Camera")
		return
	
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.global_position
	var forward = -camera.global_transform.basis.z
	var to = from + forward * projectile_range
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		print("Hit: ", result.collider.name, " at ", result.position)
		spawn_impact_marker(result.position, weapon.get_tree())
