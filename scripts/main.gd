extends Node

@onready var escalation: Node = $EscalationManager
@onready var dialogue: Node = $DialogueManager
@onready var timer: Node = $TimerScore
@onready var masseur: Node3D = $Masseur
@onready var ui: CanvasLayer = $UI

func _ready() -> void:
	ui.init(dialogue)
	dialogue.dialogue_started.connect(ui.show_dialogue)
	dialogue.dialogue_ended.connect(ui.hide_dialogue)
	escalation.game_over.connect(_on_game_over)
	ui.option_chosen.connect(_on_option_chosen)
	ui.restart_pressed.connect(_restart)

	escalation.start()
	timer.start()
	masseur.begin()

func _process(_delta: float) -> void:
	if timer.running:
		ui.update_timer(timer.elapsed)

func _on_game_over() -> void:
	var elapsed: float = timer.stop()
	ui.show_game_over(
		timer.format_time(elapsed),
		timer.format_time(timer.highscore)
	)

func _on_option_chosen(index: int) -> void:
	dialogue.choose_option(index, escalation.current_step)

func _restart() -> void:
	get_tree().reload_current_scene()
