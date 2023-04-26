extends Node

var spawn_time
var index

func _ready():
	self.scale = Vector3.ONE*0.01

func update(currtime: float):
	var current_note = Flux.current_map.diffs["default"][index]
	var time = (float(current_note.ms) - currtime) / (float(current_note.ms) - spawn_time)
	self.transform.origin = Vector3(-current_note.x+1.0, -current_note.y + 1.0, time * Flux.settings["note"]["sd"])
	
	if self.transform.origin.z < -1.0:
		self.queue_free()
