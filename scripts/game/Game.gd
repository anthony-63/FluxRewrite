extends Node3D

func _ready():
	$HUD/MapName.text = Flux.current_map.meta.artist + " - " + Flux.current_map.meta.title
	var map = Flux.current_map
	Flux.audio_manager.length = Flux.current_map.diffs["default"][-1]["ms"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Flux.settings.audio.music_volume))
	
	Flux.audio_manager.play($MusicStream)
	Flux.audio_manager.playback_speed = Flux.mods.speed
#	Flux.audio_manager.seek(Flux.mods.seek)
	AudioServer.playback_speed_scale = Flux.mods.speed
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	$HUD/TimeIntoMap.text = Flux.ms_to_min_sec_str(Flux.audio_manager.current_time) + "/" + Flux.ms_to_min_sec_str(Flux.current_map.diffs["default"][-1]["ms"])
