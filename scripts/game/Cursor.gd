extends Node

func _ready():
	self.scale = Vector3.ONE * Flux.get_setting("cursor", "scale")

func _process(_delta):
	Flux.cursor_info.x = self.transform.origin.x + (self.scale.x / 2.0)
	Flux.cursor_info.y = self.transform.origin.y + (self.scale.y / 2.0)
	if Flux.get_setting("debug", "show_cursor_hitbox"):

		$"../Draw3D".cube(Vector3(self.transform.origin.x,  self.transform.origin.y, self.transform.origin.z), Basis.IDENTITY.scaled(Vector3(Flux.settings.cursor.scale / 10.0, Flux.settings.cursor.scale / 10.0, 0.0)), Color.GREEN)

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
