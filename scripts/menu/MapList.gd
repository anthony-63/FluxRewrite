extends Node

var map_button_data = []

func _ready():
	$MapScrollVbox/MapButton.visible = false
	update_maps()
	
func update_maps():
	print("Updating maps...")
	for child in $MapScrollVbox.get_children():
		if child.name.begins_with("MapButton_"):
			child.queue_free()
			if child in $MapScrollVbox.get_children():
				child.queue_free()
	map_button_data = []
	
	for map in Flux.maps:
		map_button_data.append(map)
	var i = 0
	for data in map_button_data:
		var button = $MapScrollVbox/MapButton.duplicate()
		button.name = "MapButton_%d" % i
		button.visible = true
		button.update(data)
		i += 1
		$MapScrollVbox.add_child(button)

func _on_reload_map_list_pressed():
	Flux.reload_game()
