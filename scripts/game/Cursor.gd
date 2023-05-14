extends Node

func _ready():
	self.scale = Vector3.ONE * Flux.settings.cursor.scale

func _input(ev):
	if ev is InputEventMouseMotion:
		self.transform.origin.x = clamp(self.transform.origin.x - (ev.relative.x * (Flux.settings.cursor.sensitivity * 0.01)), -1.5, 1.5) # holy mother of BLUD ! the 0.01 stuff is Pyrule's Doing :cry:
		self.transform.origin.y = clamp(self.transform.origin.y - (ev.relative.y * (Flux.settings.cursor.sensitivity * 0.01)), -1.5, 1.5) # holy mother of BLUD ! the 0.01 stuff is Pyrule's Doing :cry:
