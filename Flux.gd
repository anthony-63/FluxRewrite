extends Node

var maps = []
var notesets = {}
var current_map = {}

var settings = {
	"note": {
		"ar": 10.0,
		"sd": 4.0,
		"approach_time": 0.0,
	},
	"ui": {
		"enable_ruwo": true,
	},
}

var mods = {
	"speed": 1.0,
}

@onready var audio_manager: AudioManager = get_node("/root/AudioManager")

func _ready():
	pass
func reload_game():
	get_tree().change_scene_to_file("res://scenes/Loading.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ms_to_min_sec_str(ms):
	var min = int(float(ms) * 0.001) / 60
	var sec = int(float(ms) * 0.001) % 60
	return str(min) + ":" + ("%02d" % sec)
