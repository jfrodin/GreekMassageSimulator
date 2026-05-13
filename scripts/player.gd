extends Node

@onready var camera: Camera3D = $"../Player/Camera3D"

# Lying-down look limits (radians). Player can look around but not sit up.
const PITCH_MIN := -0.4  # slightly downward
const PITCH_MAX := 0.6   # upward toward ceiling
const YAW_LIMIT := 0.9   # left/right limit from center

const SENSITIVITY := 0.002

var _yaw := 0.0
var _pitch := 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_yaw -= event.relative.x * SENSITIVITY
		_pitch -= event.relative.y * SENSITIVITY
		_yaw = clamp(_yaw, -YAW_LIMIT, YAW_LIMIT)
		_pitch = clamp(_pitch, PITCH_MIN, PITCH_MAX)
		camera.rotation = Vector3(_pitch, _yaw, 0.0)
