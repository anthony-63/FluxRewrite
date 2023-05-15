extends Node

func _ready():
	self.scale = Vector3.ONE * Flux.settings.cursor.scale

func _process(delta):
	Flux.cursor_area.transform.origin.x = self.transform.origin.x
	Flux.cursor_area.transform.origin.y = self.transform.origin.y
	Flux.cursor_area.scale.x = 0.2625
	Flux.cursor_area.scale.y = 0.2625

func _input(ev):
	if ev is InputEventMouseMotion:
		self.transform.origin.x = clamp(self.transform.origin.x - (ev.relative.x * (Flux.settings.cursor.sensitivity * 0.01)), -1.5, 1.5) # holy mother of BLUD ! the 0.01 stuff is Pyrule's Doing :cry:
		self.transform.origin.y = clamp(self.transform.origin.y - (ev.relative.y * (Flux.settings.cursor.sensitivity * 0.01)), -1.5, 1.5) # holy mother of BLUD ! the 0.01 stuff is Pyrule's Doing :cry:
