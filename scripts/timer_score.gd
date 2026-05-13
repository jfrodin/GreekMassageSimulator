extends Node

const HIGHSCORE_KEY := "highscore"

var elapsed := 0.0
var running := false
var highscore := 0.0

func _ready() -> void:
	highscore = _load_highscore()

func start() -> void:
	elapsed = 0.0
	running = true

func stop() -> float:
	running = false
	if elapsed > highscore:
		highscore = elapsed
		_save_highscore(highscore)
	return elapsed

func _process(delta: float) -> void:
	if running:
		elapsed += delta

func format_time(seconds: float) -> String:
	var m := int(seconds) / 60
	var s := int(seconds) % 60
	var ms := int(fmod(seconds, 1.0) * 100)
	return "%02d:%02d.%02d" % [m, s, ms]

func _save_highscore(value: float) -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("score", HIGHSCORE_KEY, value)
	cfg.save("user://scores.cfg")

func _load_highscore() -> float:
	var cfg := ConfigFile.new()
	if cfg.load("user://scores.cfg") != OK:
		return 0.0
	return cfg.get_value("score", HIGHSCORE_KEY, 0.0)
