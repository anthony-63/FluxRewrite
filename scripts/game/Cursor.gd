extends Node

func _ready():
	self.scale = Vector3.ONE * Flux.settings.cursor.scale

func _process(delta):
	Flux.cursor_info.x = self.transform.origin.x + (self.scale.x / 2.0)
	Flux.cursor_info.y = self.transform.origin.y + (self.scale.y / 2.0)

func _input(ev):
	if ev is InputEventMouseMotion:
		self.transform.origin.x = clamp(self.transform.origin.x - (ev.relative.x * (Flux.settings.cursor.sensitivity * 0.01)), -1.5, 1.5) # holy mother of BLUD ! the 0.01 stuff is Pyrule's Doing :cry:
		self.transform.origin.y = clamp(self.transform.origin.y - (ev.relative.y * (Flux.settings.cursor.sensitivity * 0.01)), -1.5, 1.5) # holy mother of BLUD ! the 0.01 stuff is Pyrule's Doing :cry:
