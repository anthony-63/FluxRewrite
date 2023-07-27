extends Camera3D

@export var yaw = 0
@export var pitch = 0

func _input(event):
	if event is InputEventMouseMotion and Flux.spinning and not Flux.replaying:
		self.look_at($"../InvisCursor".transform.origin, Vector3.UP)
#		$"../Camera3D".rotate_y(deg_to_rad(yaw))
