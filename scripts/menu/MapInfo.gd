extends Node

var selected_map: Dictionary = {}

func _ready():
	if Flux.current_map != null and Flux.current_map != {}:
		print(Flux.current_map)
		selected_map = Flux.current_map
		play_map_audio(Flux.current_map)
		
func update_map_info():
	if not selected_map.meta.artist == "":
		$ArtistAndMapper.text = "%s/%s" % [selected_map.meta.artist, selected_map.meta.mapper]
	else:
		$ArtistAndMapper.text = selected_map.meta.mapper
			
	$SongName.text = selected_map.meta.title
	
	$SongLength.text = Flux.get_map_len_str(selected_map)

func play_map_audio(map):
	if map.audio_stream == null:
		$NoAudioStream.visible = true
		$"../MusicPreview".stop()
	else:
		$NoAudioStream.visible = false
		$"../MusicPreview".stream = map.audio_stream
		$"../MusicPreview".stream.loop = true
		var play_time = 0.0
		if Flux.mods.seek == 0:
			play_time = (map.end_time / 1000.0) / 3.0
		else:
			play_time = Flux.mods.seek
		$"../MusicPreview".pitch_scale = Flux.mods.speed
		$"../MusicPreview".play(play_time)
func _on_map_button_selected(map):
	selected_map = map
	FluxMap.load_data(map)
	
	update_map_info()
	
	play_map_audio(map)
	
	
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
	$"../Transition".transition_out()
	await get_tree().create_timer(Flux.transition_time).timeout
	Flux.current_map = selected_map
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_seek_value_changed(value):
	$"../MusicPreview".play(value)


func _on_speed_value_changed(value):
	$"../MusicPreview".pitch_scale = value


func _on_stop_music_pressed():
	$"../MusicPreview".stop()
