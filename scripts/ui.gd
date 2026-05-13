extends CanvasLayer

signal option_chosen(index: int)
signal restart_pressed

@onready var timer_label: Label = $TimerLabel
@onready var dialogue_box: PanelContainer = $DialogueBox
@onready var masseur_line: Label = $DialogueBox/VBox/MasseurLine
@onready var option_buttons: Array[Button] = [
	$DialogueBox/VBox/Option1,
	$DialogueBox/VBox/Option2,
	$DialogueBox/VBox/Option3,
]
@onready var game_over_screen: PanelContainer = $GameOverScreen
@onready var time_label: Label = $GameOverScreen/VBox/TimeLabel
@onready var highscore_label: Label = $GameOverScreen/VBox/HighscoreLabel
@onready var restart_button: Button = $GameOverScreen/VBox/RestartButton

func _ready() -> void:
	for i in option_buttons.size():
		var idx := i
		option_buttons[i].pressed.connect(func(): option_chosen.emit(idx))
	restart_button.pressed.connect(func(): restart_pressed.emit())

func show_dialogue(entry: Dictionary) -> void:
	masseur_line.text = entry["masseur"]
	var opts: Array = entry["options"]
	for i in option_buttons.size():
		if i < opts.size():
			option_buttons[i].text = opts[i]["text"]
			option_buttons[i].visible = true
		else:
			option_buttons[i].visible = false
	dialogue_box.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_dialogue() -> void:
	dialogue_box.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func show_game_over(time_str: String, highscore_str: String) -> void:
	time_label.text = "You lasted: " + time_str
	highscore_label.text = "Best: " + highscore_str
	game_over_screen.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func update_timer(elapsed: float) -> void:
	var m := int(elapsed) / 60
	var s := int(elapsed) % 60
	var ms := int(fmod(elapsed, 1.0) * 100)
	timer_label.text = "%02d:%02d.%02d" % [m, s, ms]
