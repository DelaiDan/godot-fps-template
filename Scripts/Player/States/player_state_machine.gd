class_name PlayerStateMachine extends Node

@export var debug: bool = false
@export var player_controller: PlayerController

func _ready() -> void:
	if not player_controller and owner is PlayerController:
		player_controller = owner

func _process(delta: float) -> void:
	if player_controller:
		player_controller.state_chart.set_expression_property("Player Hitting Head", player_controller.crouch_check.is_colliding())
		player_controller.state_chart.set_expression_property("Looking at: ", player_controller.interaction_raycast.current_object)
