extends Node

func _ready():
	self.scale = Vector3.ONE * Flux.get_setting("cursor", "scale")

func _process(d):
	if Flux.replaying: return
	
func _input(ev):
	if ev is InputEventMouseMotion and not Flux.replaying:
		self.transform.origin.x -= (ev.relative.x * (Flux.get_setting("cursor", "sensitivity") / 100))
		self.transform.origin.y -= (ev.relative.y * (Flux.get_setting("cursor", "sensitivity") / 100))
#		print("\nclamp coords\nx<{CXA}, {CXB}>\ny<{CYA}, {CYB}>".format({
#			"CXA": $"../HUD/Border".scale.x * -1.5,
#			"CXB": $"../HUD/Border".scale.x * 1.5,
#			"CYA": $"../HUD/Border".scale.y * -1.5,
#			"CYB": $"../HUD/Border".scale.y * 1.5
#		}))
