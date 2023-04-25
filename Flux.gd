extends Node

var maps = []
var current_map: FluxMap

var settings = {
	"note": {
		"ar": 10.0,
		"sd": 4.0,
	},
	"ui": {
		"enable_ruwo": true,
	},
}

@onready var time_manager: TimeManager = get_node("/root/TimeManager")

func _ready():
	pass
	
func set_current_map(id):
	for map in maps:
		if map.meta["id"] == id:
			current_map = map
			break
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ms_to_min_sec_str(ms):
	var min = int(float(ms) * 0.001) / 60
	var sec = int(float(ms) * 0.001) % 60
	return str(min) + ":" + ("%02d" % sec)
