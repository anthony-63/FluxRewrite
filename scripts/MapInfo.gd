extends Node

var selected_map = {}

func _on_map_button_selected(map):
	$ArtistAndMapper.text = "%s/%s" % [map.meta.artist, map.meta.mapper]
	$SongName.text = map.meta.title
	$SongLength.text = Flux.ms_to_min_sec_str(map.diffs.default[-1].ms)
	selected_map = map
	$PlayButton.visible = true

func _on_play_button_pressed():
	Flux.current_map = selected_map
	$"../Transition/Animation".play("out")
	

func transition_finished():
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
