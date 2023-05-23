extends Node

var maps = []
var notesets = {}
var current_map = {}
var transition_time:float = 1
var fullscreen = false
var update_selected_map = false

const version_string = "FluxRewrite v0.2"

var cursor_info: Dictionary = {
	"x": 0.0, # m
	"y": 0.0, # m
	"w": 0.2625, # m
	"h": 0.2625, # m
}

var map_finished_info = {
	"max_combo": 0,
	"misses": 0,
	"accuracy": 0,
	"passed": false,
	"played": false,
}

var game_stats = {
	"misses": 0,
	"hits": 0,
	"combo": 0,
	"max_combo": 0,
	
	"hp": 0.0,
	"max_hp": 5.0,
	"hp_per_hit": 0.5,
	"hp_per_miss": 1.0,
}

var default_settings = {
	"note": {
		"ar": 10.0, # m/s
		"sd": 4.0, # m
		"approach_time": 0.0, # s
		"fade": false,
	},
	"debug": {
		"show_note_hitbox": false,
		"show_cursor_hitbox": false,
	},
	"game": {
		"hitwindow": 58, # ms
		"hitbox": 1.14, # m
		"wait_time": 1.5, # s
	},
	"cursor": {
		"sensitivity": 1.0, # m/s
		"scale": 1.9, # m
	},
	"ui": {
		"enable_ruwo": true,
	},
	"sets": {
		"noteset": "default"
	},
	"audio": {
		"music_volume": 0.5, # %
	}
}

var settings = default_settings

var mods = {
	"speed": 1.0,
	"seek": 0,
	"endseek": -1,
}

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if fullscreen: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen = !fullscreen

func reload_game():
	get_tree().change_scene_to_file("res://scenes/Loading.tscn")

func reload_game_stylish():
	if $"..".has_node("Transition"):
		$"../Transition".transition_out()
		await get_tree().create_timer(transition_time).timeout
		get_tree().change_scene_to_file("res://scenes/Loading.tscn")

func ms_to_min_sec_str(ms):
	var mins = int(float(ms) * 0.001) / 60
	var secs = int(float(ms) * 0.001) % 60
	return str(mins) + ":" + ("%02d" % secs)

func get_map_len_str(map):
	var map_len = "err:err"
	if len(map.diffs.default) > 0:
		map_len = Flux.ms_to_min_sec_str(map.diffs.default[-1].ms)
	return map_len
