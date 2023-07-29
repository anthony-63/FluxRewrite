extends Node

@export var cursorset: Array
@export var cursor_index: int = 0

func _ready():
	self.scale = Vector3.ONE * Flux.get_setting("cursor", "scale")
	cursorset = Flux.cursorsets[Flux.get_setting("sets", "cursorset")]
	self.texture = cursorset[cursor_index % len(cursorset)]
	self.alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS
	cursor_index += 1

func update_cursor_hitboxes():
	Flux.cursor_pos = self.transform.origin

func _process(_delta):
	if Flux.replaying:
		self.transform.origin = $"../InvisCursor".transform.origin
		update_cursor_hitboxes()

func _input(ev):
	if Flux.replaying: return
	if ev is InputEventMouseMotion:
		self.transform.origin = $"../InvisCursor".transform.origin
		if Flux.spinning:
			pass
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
