extends Node3D

func _ready():
	$HUD/MapName.text = Flux.current_map.meta["artist"] + " - " + Flux.current_map.meta["title"]
	var map = Flux.current_map
	Flux.time_manager.length = Flux.current_map.diffs["default"][-1]["ms"]

func _process(delta):
	$HUD/TimeIntoMap.text = str(Flux.time_manager.last_time)
