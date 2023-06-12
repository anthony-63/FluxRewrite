extends Node

func _ready():
	self.scale = Vector3.ONE * Flux.get_setting("cursor", "scale")

func _process(d):
	if Flux.replaying: return
	self.transform.origin.x = tan($"../Camera3D".pitch) * $"../Camera3D".transform.origin.z
	self.transform.origin.y = tan($"../Camera3D".yaw) * $"../Camera3D".transform.origin.z

#func _input(ev):
#	if ev is InputEventMouseMotion:
#
##		print("\nclamp coords\nx<{CXA}, {CXB}>\ny<{CYA}, {CYB}>".format({
##			"CXA": $"../HUD/Border".scale.x * -1.5,
##			"CXB": $"../HUD/Border".scale.x * 1.5,
##			"CYA": $"../HUD/Border".scale.y * -1.5,
##			"CYB": $"../HUD/Border".scale.y * 1.5
##		}))
