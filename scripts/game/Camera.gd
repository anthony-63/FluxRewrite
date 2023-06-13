extends Node

@export var yaw = 0
@export var pitch = 0

func _input(event):
	if event is InputEventMouseMotion and Flux.get_setting("game", "spin"):
		yaw = fmod(yaw + event.relative.y * Flux.get_setting("cursor", "sensitivity") / 150.0, 360) 
		pitch = max(min(pitch + event.relative.x * Flux.get_setting("cursor", "sensitivity") / 150.0, 90),-90)
		$"../Camera3D".rotation_degrees.x = pitch
		$"../Camera3D".rotation_degrees.y = yaw
		
#		$"../Camera3D".rotate_y(deg_to_rad(yaw))
