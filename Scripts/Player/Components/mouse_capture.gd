class_name MouseCaptureComponent extends Node

@export var debug: bool = false
@export_category("Mouse Capture COmponent")

@export var current_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_CAPTURED
@export var mouse_sensitivity : float = 0.005

var _capture_mouse: bool
var _mouse_input: Vector2

func _unhandled_input(event: InputEvent) -> void:
	_capture_mouse = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if _capture_mouse:
		_mouse_input.x += -event.screen_relative.x * mouse_sensitivity
		_mouse_input.y += -event.screen_relative.y * mouse_sensitivity

	if debug:
		print(_mouse_input)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = current_mouse_mode


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_mouse_input = Vector2.ZERO
