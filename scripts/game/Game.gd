extends Node3D

func _ready():
	$HUD/MapName.text = Flux.current_map.meta.artist + " - " + Flux.current_map.meta.title
	var map = Flux.current_map
	Flux.audio_manager.length = Flux.current_map.diffs["default"][-1]["ms"]
	Flux.audio_manager.play($MusicStream)

func _process(delta):
	$HUD/TimeIntoMap.text = Flux.ms_to_min_sec_str(Flux.audio_manager.current_time) + "/" + Flux.ms_to_min_sec_str(Flux.current_map.diffs["default"][-1]["ms"])
