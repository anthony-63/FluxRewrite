extends Node

func _ready():
	Flux.cursor_area_ref = $Area
	self.scale = Vector3.ONE * Flux.get_setting("cursor", "scale")

func _process(_delta):
	$Area.transform.origin.z = 0.0
	
func _input(ev):
	if ev is InputEventMouseMotion:
		if Flux.get_setting("game", "spin"):
			self.transform.origin = $"../InvisCursor".transform.origin
		else:
			self.transform.origin.x -= (ev.relative.x * (Flux.get_setting("cursor", "sensitivity") / 100))
			self.transform.origin.y -= (ev.relative.y * (Flux.get_setting("cursor", "sensitivity") / 100))
		self.transform.origin = Vector3(
			clamp(self.transform.origin.x, $"../HUD/Border".scale.x * -1.5, $"../HUD/Border".scale.x * 1.5),
			clamp(self.transform.origin.y, $"../HUD/Border".scale.y * -1.5, $"../HUD/Border".scale.y * 1.5),
			0
		)
		
#		print("\nclamp coords\nx<{CXA}, {CXB}>\ny<{CYA}, {CYB}>".format({
#			"CXA": $"../HUD/Border".scale.x * -1.5,
#			"CXB": $"../HUD/Border".scale.x * 1.5,
#			"CYA": $"../HUD/Border".scale.y * -1.5,
#			"CYB": $"../HUD/Border".scale.y * 1.5
#		}))
