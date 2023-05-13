extends Node

var dt = 0

func _ready():
	self.scale = Vector3.ONE * Flux.settings.cursor.scale

func _process(delta):
	dt = delta

func _input(ev):
	if ev is InputEventMouseMotion:
		self.transform.origin.x = clamp(self.transform.origin.x - (dt * ev.relative.x * Flux.settings.cursor.sensitivity), -1.5, 1.5)
		self.transform.origin.y = clamp(self.transform.origin.y - (dt * ev.relative.y * Flux.settings.cursor.sensitivity), -1.5, 1.5)
