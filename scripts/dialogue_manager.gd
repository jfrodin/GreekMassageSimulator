extends Node

signal dialogue_started(options: Array)
signal dialogue_ended

@onready var escalation: Node = $"../EscalationManager"

# Dialogue per escalation step.
# Each entry: { "masseur": String, "options": [ { "text": String, "effect": float } ] }
# effect > 0 = buys time (seconds added to step timer negatively = delays advance)
# effect < 0 = backfires (seconds subtracted = rushes advance)
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
	# Step 5 — final approach (no dialogue — game over triggered by escalation_manager)
	{
		"masseur": "And now… de center of harmony. Do not be afraid. Is perfectly normal.",
		"options": []
	},
]

var _active := false

func trigger_dialogue(step: int) -> void:
	if _active or step >= DIALOGUE.size():
		return
	_active = true
	var entry: Dictionary = DIALOGUE[step]
	dialogue_started.emit(entry)

func choose_option(option_index: int, step: int) -> void:
	if not _active:
		return
	var options: Array = DIALOGUE[step]["options"]
	if option_index < 0 or option_index >= options.size():
		return

	var effect: float = options[option_index]["effect"]
	# Positive effect delays the step timer by reducing how far along we are
	escalation.apply_time_effect(-effect)

	_active = false
	dialogue_ended.emit()
