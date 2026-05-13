extends Node

signal dialogue_started(entry: Dictionary)
signal dialogue_ended

@onready var escalation: Node = $"../EscalationManager"

const ANSWER_TIME := 10.0

const DIALOGUE := [
	# Step 0 — shoulders
	{
		"masseur": "Ve begin vith de shoulders. You are very tense. Is not good.",
		"options": [
			{"text": "Yes, I've been stressed at work.", "effect": 8.0},
			{"text": "That feels… fine, thanks.", "effect": 4.0},
			{"text": "Are you certified?", "effect": -6.0},
		]
	},
	# Step 1 — upper back
	{
		"masseur": "De upper back — ah, yes. De ancient Greeks call dis area de 'seat of courage'. You have much tension here.",
		"options": [
			{"text": "Fascinating. Tell me more about the Greeks.", "effect": 12.0},
			{"text": "Can you stay on the shoulders a bit longer?", "effect": 6.0},
			{"text": "I think I'm good actually.", "effect": -8.0},
		]
	},
	# Step 2 — lower back
	{
		"masseur": "Now de lower back. My father teach me dis. His father teach him. Is very ancient technique.",
		"options": [
			{"text": "Your family sounds very traditional.", "effect": 10.0},
			{"text": "Mm. Sure.", "effect": 3.0},
			{"text": "Is this… necessary?", "effect": -5.0},
		]
	},
	# Step 3 — glutes
	{
		"masseur": "De gluteus — is de powerhouse of de body. Hippocrates himself write about dis. Is perfectly normal.",
		"options": [
			{"text": "Did Hippocrates really write about that?", "effect": 14.0},
			{"text": "…okay.", "effect": 2.0},
			{"text": "I'd rather you didn't.", "effect": -10.0},
		]
	},
	# Step 4 — upper thigh
	{
		"masseur": "Almost dere. De upper thigh hold all de stress from de lower regions. Ve must release it. Is science.",
		"options": [
			{"text": "What kind of science exactly?", "effect": 10.0},
			{"text": "I feel very released already, thank you.", "effect": 5.0},
			{"text": "Please stop.", "effect": -12.0},
		]
	},
	# Step 5 — final approach (no options, game over incoming)
	{
		"masseur": "And now… de center of harmony. Do not be afraid. Is perfectly normal.",
		"options": []
	},
]

var _active := false
var _deadline_ms := 0.0

func trigger_dialogue(step: int) -> void:
	if _active or step >= DIALOGUE.size():
		return
	_active = true
	_deadline_ms = Time.get_ticks_msec() + ANSWER_TIME * 1000.0
	get_tree().create_timer(ANSWER_TIME).timeout.connect(_on_timeout)
	dialogue_started.emit(DIALOGUE[step])

func answer_time_left() -> float:
	if not _active:
		return 0.0
	return maxf(0.0, (_deadline_ms - Time.get_ticks_msec()) / 1000.0)

func choose_option(option_index: int, step: int) -> void:
	if not _active:
		return
	var options: Array = DIALOGUE[step]["options"]
	if option_index < 0 or option_index >= options.size():
		return
	var effect: float = options[option_index]["effect"]
	escalation.apply_time_effect(-effect)
	_end_dialogue()

func _on_timeout() -> void:
	if not _active:
		return
	_end_dialogue()

func _end_dialogue() -> void:
	_active = false
	dialogue_ended.emit()
