extends Node3D

func _ready():
	# show the transition (dont do shit with it yet tho)
	$Transition.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	$HUD/MapName.text = Flux.current_map.meta.artist + " - " + Flux.current_map.meta.title
	var map = Flux.current_map
	Flux.audio_manager.length = Flux.current_map.diffs["default"][-1]["ms"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Flux.settings.audio.music_volume))
	
	await get_tree().create_timer(Flux.default_settings.game.wait_time).timeout
	
	Flux.audio_manager.play($MusicStream)
	Flux.audio_manager.playback_speed = Flux.mods.speed
#	Flux.audio_manager.seek(Flux.mods.seek)
	AudioServer.playback_speed_scale = Flux.mods.speed

func _process(delta):
	$HUD/TimeIntoMap.text = Flux.ms_to_min_sec_str(Flux.audio_manager.current_time) + "/" + Flux.ms_to_min_sec_str(Flux.current_map.diffs["default"][-1]["ms"])
	$HUD/Misses/MissAmount.text = str(Flux.game_stats.misses)
	$HUD/Hits/HitAmount.text = str(Flux.game_stats.hits)
	$HUD/Total/TotalAmount.text = str(Flux.game_stats.misses + Flux.game_stats.hits)
