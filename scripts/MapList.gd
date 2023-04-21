extends Node

const map_button_scene = preload("res://scenes/MapButton.tscn")

func _ready():
#	for map in Flux.maps:
#		var button = map_button_scene.instantiate()
#		if map.meta.has("artist"):
#			button.get_node("title").text = map.meta["artist"] + " - " + map.meta["song_name"]
#		else:
#			button.get_node("title").text = "%s" % (map.meta["song_name"])
#		add_child(button)
	var button = map_button_scene.instantiate()
	add_child(button)
