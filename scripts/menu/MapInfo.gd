extends Node

var selected_map = {}

func _on_map_button_selected(map):
	$ArtistAndMapper.text = "%s/%s" % [map.meta.artist, map.meta.mapper]
	$SongName.text = map.meta.title
	$SongLength.text = Flux.ms_to_min_sec_str(map.diffs.default[-1].ms)
	selected_map = map
	$PlayButton.visible = true

func _on_play_button_pressed():
	$"../Transition".transition_out()
	await get_tree().create_timer(Flux.transition_time).timeout
	print(Flux.settings.sets.noteset)
	Flux.current_map = selected_map
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
