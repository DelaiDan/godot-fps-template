class_name Weapon extends Resource

@export var weapon_name: String = "Base Pistol"
@export var damage: float = 25.0
@export var max_ammo: int = 12

@export var weapon_model: PackedScene
@export var weapon_position: Vector3 = Vector3(0.2, -0.2, -0.3)

func spawn_impact_marker(position: Vector3, tree: SceneTree) -> void:
	var marker = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.1, 0.1, 0.1)
	marker.mesh = box
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	marker.set_surface_override_material(0, material)
	
	tree.current_scene.add_child(marker)
	marker.global_position = position
	
	#Auto Remove
	tree.create_timer(2.0).timeout.connect(marker.queue_free)