extends Node

var spawn_time
var ms
var index
var hittable: bool
var unhittable: bool

func _ready():
	self.scale = Vector3.ONE*0.865

func update(currtime: float):
	var current_note = Flux.current_map.diffs["default"][index]
	var time = (float(current_note.ms) - currtime) / (float(current_note.ms) - spawn_time)
	self.transform.origin = Vector3(-current_note.x + 1.0, -current_note.y + 1.0, time * Flux.settings["note"]["sd"])
	
	if currtime >= ms && not unhittable: hittable = true
	if currtime >= ms + Flux.settings.game.hitwindow && hittable: 
		hittable = false
		unhittable = true
		Flux.game_stats.misses += 1
	
	$debug_label.text = "%s\n%s" % [str(hittable), str(unhittable)]
	
	var a2 = Area2D.new()
	a2.transform.origin.x = self.transform.origin.x
	a2.transform.origin.y = self.transform.origin.y
	a2.scale.x = Flux.settings.game.hitbox
	a2.scale.y = Flux.settings.game.hitbox

	if Flux.cursor_area.overlaps_area(a2): # this dont work....
		hittable = false
		unhittable = true
		Flux.game_stats.hits += 1
	
	if self.transform.origin.z < -2.0:
		queue_free()
