extends Node

func _ready():
	self.scale = Vector3.ONE * Flux.settings.cursor.scale

func _input(ev):
	if ev is InputEventMouseMotion:
		self.transform.origin.x -= (ev.relative.x * (Flux.settings.cursor.sensitivity / 100))
		self.transform.origin.y -= (ev.relative.y * (Flux.settings.cursor.sensitivity / 100))
		
#		print("\nclamp coords\nx<{CXA}, {CXB}>\ny<{CYA}, {CYB}>".format({
#			"CXA": $"../HUD/Border".scale.x * -1.5,
#			"CXB": $"../HUD/Border".scale.x * 1.5,
#			"CYA": $"../HUD/Border".scale.y * -1.5,
#			"CYB": $"../HUD/Border".scale.y * 1.5
#		}))
