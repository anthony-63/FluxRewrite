extends ColorRect

var wait_time:float = 1.0

func _ready():
	show()
	material.set("shader_parameter/circle_size", 0.0)
	material.set("shader_parameter/screen_width", get_viewport().size.x)
	material.set("shader_parameter/screen_height", get_viewport().size.y)
	await get_tree().create_timer(wait_time).timeout
	$Animation.play("in")
