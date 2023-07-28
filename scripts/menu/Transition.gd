extends ColorRect

func transition_in():
	$Animation.play("in")
	await get_tree().create_timer(Flux.transition_time).timeout
	hide()

func transition_out():
	show()
	$Animation.play("out")
	await get_tree().create_timer(Flux.transition_time).timeout
	hide()

func _ready():
	show()
	material.set("shader_parameter/circle_size", 0.0)
	material.set("shader_parameter/screen_width", get_viewport().size.x)
	material.set("shader_parameter/screen_height", get_viewport().size.y)
	await get_tree().create_timer(Flux.transition_time * 0.5).timeout
	transition_in()
