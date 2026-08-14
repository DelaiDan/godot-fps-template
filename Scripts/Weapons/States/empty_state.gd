extends WeaponState

func _on_empty_state_state_entered() -> void:
	print("Weapon empty!")

func _on_empty_state_state_processing(delta: float) -> void:
	pass
