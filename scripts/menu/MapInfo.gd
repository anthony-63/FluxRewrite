extends Node

var selected_map: Dictionary = {}

func update_map_info():
	if not selected_map.meta.artist == "":
		$ArtistAndMapper.text = "%s/%s" % [selected_map.meta.artist, selected_map.meta.mapper]
	else:
		$ArtistAndMapper.text = selected_map.meta.mapper
			
	$SongName.text = selected_map.meta.title
	
	$SongLength.text = Flux.get_map_len_str(selected_map)

func _on_map_button_selected(map):
	selected_map = map
	update_map_info()
	$PlayButton.visible = true
	Flux.map_finished_info.max_combo = 0
	Flux.map_finished_info.accuracy = 0
	Flux.map_finished_info.misses = 0
	Flux.map_finished_info.played = false
	
func _process(_delta):
	if Flux.update_selected_map:
		selected_map = Flux.current_map
		update_map_info()
		$PlayButton.visible = true
		Flux.update_selected_map = false
	
	$"Max Combo".text = "Max combo: " + str(Flux.map_finished_info.max_combo)
	$Accuracy.text = "Accuracy: %.2f" % Flux.map_finished_info.accuracy 
	$Misses.text = "Misses: " + str(Flux.map_finished_info.misses)
	
	if Flux.map_finished_info.played:
		if Flux.map_finished_info.passed:
			$PassedOrFailed.text = "Passed!"
		else:
			$PassedOrFailed.text = "Failed!"
	else:
		$PassedOrFailed.text = "Not played yet."
	
func _on_play_button_pressed():
	Flux.replaying = false
	$"../Transition".transition_out()
	await get_tree().create_timer(Flux.transition_time).timeout
	Flux.current_map = selected_map
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
