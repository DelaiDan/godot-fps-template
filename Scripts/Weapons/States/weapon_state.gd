class_name WeaponState extends Node

var weapon_controller: WeaponController

func _ready()-> void:
	if %WeaponStateMachine and %WeaponStateMachine is WeaponStateMachine:
		weapon_controller = %WeaponStateMachine.weapon_controller
