extends Node

signal step_changed(step: int)
signal game_over

# How long each step lasts by default (seconds)
const BASE_STEP_DURATION := 30.0

# 6 escalation steps (0 = shoulders, 5 = groin / game over)
var current_step := 0
var step_timer := 0.0
var step_duration := BASE_STEP_DURATION
var running := false

# Called by dialogue_manager when player picks a response
func apply_time_effect(seconds: float) -> void:
	step_timer += seconds

func pause() -> void:
	running = false

func resume() -> void:
	running = true

func start() -> void:
	current_step = 0
	step_timer = 0.0
	step_duration = BASE_STEP_DURATION
	running = true

func _process(delta: float) -> void:
	if not running:
		return

	step_timer += delta

	if step_timer >= step_duration:
		_advance_step()

func _advance_step() -> void:
	step_timer = 0.0
	current_step += 1

	if current_step >= 6:
		running = false
		game_over.emit()
		return

	# Each step slightly shorter — the masseuse gets into it
	step_duration = BASE_STEP_DURATION * pow(0.85, current_step)
	step_changed.emit(current_step)
