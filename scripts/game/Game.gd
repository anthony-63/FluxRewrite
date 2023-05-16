extends Node3D

func _ready():
	$Transition.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$HUD/MapName.text = Flux.current_map.meta.artist + " - " + Flux.current_map.meta.title
	Flux.audio_manager.length = Flux.current_map.diffs["default"][-1]["ms"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Flux.settings.audio.music_volume))
	
	await get_tree().create_timer(Flux.default_settings.game.wait_time).timeout
	
#	Flux.audio_manager.seek(-Flux.default_settings.game.wait_time)
	Flux.audio_manager.play($MusicStream)
	Flux.audio_manager.playback_speed = Flux.mods.speed
#	Flux.audio_manager.seek(Flux.mods.seek)
	AudioServer.playback_speed_scale = Flux.mods.speed

func reset_game():
		Flux.game_stats.misses = 0
		Flux.game_stats.hits = 0
		Flux.audio_manager = get_node("/root/AudioManager")
		$NoteSpawner.note_index = 0
		for child in $NoteSpawner.get_children():
			child.queue_free()

func _process(_delta):
	$HUD/TimeIntoMap.text = Flux.ms_to_min_sec_str(Flux.audio_manager.current_time) + "/" + Flux.ms_to_min_sec_str(Flux.current_map.diffs["default"][-1]["ms"])
	$HUD/Misses/MissAmount.text = str(Flux.game_stats.misses)
	$HUD/Hits/HitAmount.text = str(Flux.game_stats.hits)
	$HUD/Total/TotalAmount.text = str(Flux.game_stats.misses + Flux.game_stats.hits)
	
	if Input.is_action_just_pressed("leave_map"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		reset_game()
		
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")
