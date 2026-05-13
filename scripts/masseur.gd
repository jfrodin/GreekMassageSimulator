extends Node3D

@onready var dialogue_manager: Node = $"../DialogueManager"
@onready var escalation_manager: Node = $"../EscalationManager"

# Body-part target positions (relative to massage table origin).
# Placeholder values — tweak once real geometry is in place.
const STEP_POSITIONS := [
	Vector3(0.0, 1.2, 0.6),   # 0 shoulders
	Vector3(0.0, 1.0, 0.3),   # 1 upper back
	Vector3(0.0, 0.8, 0.0),   # 2 lower back
	Vector3(0.0, 0.6, -0.2),  # 3 glutes
	Vector3(0.0, 0.4, -0.4),  # 4 upper thigh
	Vector3(0.0, 0.2, -0.6),  # 5 groin
]

const MOVE_SPEED := 0.4  # units per second

var _target_pos: Vector3
var _moving := false

func _ready() -> void:
	escalation_manager.step_changed.connect(_on_step_changed)
	escalation_manager.game_over.connect(_on_game_over)
	_target_pos = STEP_POSITIONS[0]
	position = _target_pos

func _process(delta: float) -> void:
	if _moving:
		position = position.move_toward(_target_pos, MOVE_SPEED * delta)
		if position.is_equal_approx(_target_pos):
			_moving = false
			dialogue_manager.trigger_dialogue(escalation_manager.current_step)

func _on_step_changed(step: int) -> void:
	if step < STEP_POSITIONS.size():
		_target_pos = STEP_POSITIONS[step]
		_moving = true

func _on_game_over() -> void:
	_target_pos = STEP_POSITIONS[STEP_POSITIONS.size() - 1]
	_moving = true
