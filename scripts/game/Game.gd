extends Node3D

func _ready():
	Flux.game_stats.hp = Flux.game_stats.max_hp
	
	reset_game()
	$AudioManager.connect("finished", game_finished)
	$Transition.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$HUD/MapName.text = Flux.current_map.meta.artist + " - " + Flux.current_map.meta.title
	$AudioManager.length = Flux.current_map.diffs["default"][-1]["ms"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Flux.settings.audio.music_volume))
	
	await get_tree().create_timer(Flux.default_settings.game.wait_time).timeout
	
#	Flux.audio_manager.seek(-Flux.default_settings.game.wait_time)
	$AudioManager.play($MusicStream)
	$AudioManager.playback_speed = Flux.mods.speed
#	Flux.audio_manager.seek(Flux.mods.seek)
	AudioServer.playback_speed_scale = Flux.mods.speed
	
func reset_game():
		Flux.game_stats.misses = 0
		Flux.game_stats.hits = 0
		$NoteSpawner.note_index = 0
		for child in $NoteSpawner.get_children():
			child.queue_free()

func game_finished():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

func _process(_delta):
	$HUD/TimeIntoMap.text = Flux.ms_to_min_sec_str($AudioManager.current_time) + "/" + Flux.ms_to_min_sec_str(Flux.current_map.diffs["default"][-1]["ms"])
	$HUD/Misses/MissAmount.text = str(Flux.game_stats.misses)
	$HUD/Hits/HitAmount.text = str(Flux.game_stats.hits)
	$HUD/Total/TotalAmount.text = str(Flux.game_stats.hits + Flux.game_stats.misses)
	
	$HUD/HealthBarViewport/HealthBarProgress.max_value = Flux.game_stats.max_hp
	$HUD/HealthBarViewport/HealthBarProgress.value = Flux.game_stats.hp
	
	if Input.is_action_just_pressed("leave_map"):
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")
