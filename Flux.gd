extends Node

var maps = []
var notesets = {}
var current_map = {}
var transition_time:float = 1
var fullscreen = false

var cursor_info: Dictionary = {
	"x": 0.0,
	"y": 0.0,
	"w": 0.2625,
	"h": 0.2625,
}

var game_stats = {
	"misses": 0,
	"hits": 0,
}

var default_settings = {
	"note": {
		"ar": 10.0,
		"sd": 4.0,
		"approach_time": 0.0,
	},
	"game": {
		"hitwindow": 58,
		"hitbox": 1.14,
		"wait_time": 1.5,
	},
	"cursor": {
		"sensitivity": 1,
		"scale": 1.9,
	},
	"ui": {
		"enable_ruwo": true, # YEAHHHHH ! ! ! ! ! !
	},
	"sets": {
		"noteset": "default"
	},
	"audio": {
		"music_volume": 5.0,
	}
}

var settings = default_settings

var mods = {
	"speed": 1.0,
	"seek": 0,
	"endseek": -1
}

@onready var audio_manager: AudioManager = get_node("/root/AudioManager")
	
func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if fullscreen: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
		fullscreen = !fullscreen

func reload_game():
	get_tree().change_scene_to_file("res://scenes/Loading.tscn")

func ms_to_min_sec_str(ms):
	var min = int(float(ms) * 0.001) / 60
	var sec = int(float(ms) * 0.001) % 60
	return str(min) + ":" + ("%02d" % sec)
