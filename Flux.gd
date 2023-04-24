extends Node

var maps = []
var current_map: FluxMap

func _ready():
	pass # Replace with function body.

func set_current_map(id):
	for map in maps:
		if map.meta["id"] == id:
			current_map = map
			break
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
