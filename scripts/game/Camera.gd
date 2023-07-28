extends Camera3D

func _input(ev):
	if ev is InputEventMouseMotion and Flux.spinning and not Flux.replaying:
		var mouse_sens = ev.relative * (Flux.get_setting("cursor", "sensitivity") / 100.0)
		$"../Camera3D".rotation_degrees -= Vector3(mouse_sens.y, mouse_sens.x, 0) * 10
#		self.look_at($"../InvisCursor".transform.origin, Vector3.UP)
#		$"../Camera3D".rotate_y(deg_to_rad(yaw))
