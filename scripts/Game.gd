extends Node3D

func _ready():
	$HUD/MapName.text = Flux.current_map.meta.artist + " - " + Flux.current_map.meta.title
	var map = Flux.current_map
	Flux.time_manager.length = Flux.current_map.diffs["default"][-1]["ms"]
	Flux.time_manager.start()

func _process(delta):
	$HUD/TimeIntoMap.text = Flux.ms_to_min_sec_str(Flux.time_manager.current_time) + "/" + Flux.ms_to_min_sec_str(Flux.current_map.diffs["default"][-1]["ms"])
