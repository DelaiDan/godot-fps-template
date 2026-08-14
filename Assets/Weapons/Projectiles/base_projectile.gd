class_name BaseProjectile extends Area3D

var velocity: Vector3
var damage: float

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	get_tree().create_timer(3.0).timeout.connect(queue_free)
	
func _physics_process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var start_pos = global_position
	var end_pos = global_position + velocity * delta

	var query = PhysicsRayQueryParameters3D.create(start_pos, end_pos)
	query.collision_mask = 1
	var result = space_state.intersect_ray(query)

	if result:
		global_position = result.position
		_on_body_entered(result.collider)
		return

	global_position = end_pos


func setup(vel: Vector3, dmg: float) -> void:
	velocity = vel
	damage = dmg


func _on_body_entered(body: Node3D) -> void:
	print("Projectile hit: ", body.name, " at ", global_position)
	_spawn_impact_marker(global_position)
	queue_free()


func _spawn_impact_marker(position: Vector3) -> void:
	var marker = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.1, 0.1, 0.1)
	marker.mesh = box
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	marker.set_surface_override_material(0, material)
	
	get_tree().current_scene.add_child(marker)
	marker.global_position = position
	
	#Auto Remove
	get_tree().create_timer(2.0).timeout.connect(marker.queue_free)
	
