extends Node

func _ready():
	self.scale = Vector3.ONE * Flux.get_setting("cursor", "scale")

func _process(d):
	if Flux.replaying: return
	
func _input(ev):
	if ev is InputEventMouseMotion and not Flux.replaying:
		var mouse_sens = ev.relative * (Flux.get_setting("cursor", "sensitivity") / 100.0)
		if Flux.spinning:
			$"../Camera3D".rotation_degrees -= Vector3(mouse_sens.y, mouse_sens.x, 0) * 10
			
			var cam_rot = Vector2(tan($"../Camera3D".rotation.y), tan($"../Camera3D".rotation.x))
			var cam_vec = Vector2($"../Camera3D".position.x, $"../Camera3D".position.y)
			var cursor_pos = cam_vec + cam_rot * -$"../Camera3D".position.z
			self.transform.origin.x = cursor_pos.x
			self.transform.origin.y = cursor_pos.y
		else:
			self.transform.origin.x -= mouse_sens.x
			self.transform.origin.y -= mouse_sens.y
