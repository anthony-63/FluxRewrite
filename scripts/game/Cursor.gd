extends Node

func _ready():
	self.scale = Vector3.ONE * Flux.get_setting("cursor", "scale")

func update_cursor_hitboxes():
	Flux.cursor_pos = Vector2(self.transform.origin.x + self.scale.x / 2.0, self.transform.origin.y + self.scale.y / 2.0)

func _process(_delta):
	if Flux.replaying:
		self.transform.origin = $"../InvisCursor".transform.origin
		update_cursor_hitboxes()

func _input(ev):
	if Flux.replaying: return
	if ev is InputEventMouseMotion:
		if Flux.spinning:
			self.transform.origin = $"../InvisCursor".transform.origin
		else:
			self.transform.origin.x -= (ev.relative.x * (Flux.get_setting("cursor", "sensitivity") / 100))
			self.transform.origin.y -= (ev.relative.y * (Flux.get_setting("cursor", "sensitivity") / 100))
		self.transform.origin = Vector3(
			clamp(self.transform.origin.x, $"../HUD/Border".scale.x * -1.5, $"../HUD/Border".scale.x * 1.5),
			clamp(self.transform.origin.y, $"../HUD/Border".scale.y * -1.5, $"../HUD/Border".scale.y * 1.5),
			0
		)
		update_cursor_hitboxes()
#		print("\nclamp coords\nx<{CXA}, {CXB}>\ny<{CYA}, {CYB}>".format({
#			"CXA": $"../HUD/Border".scale.x * -1.5,
#			"CXB": $"../HUD/Border".scale.x * 1.5,
#			"CYA": $"../HUD/Border".scale.y * -1.5,
#			"CYB": $"../HUD/Border".scale.y * 1.5
#		}))
