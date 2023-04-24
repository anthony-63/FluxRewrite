extends Node3D

func _ready():
	$HUD/MapName.text = Flux.current_map.meta["artist"] + " - " + Flux.current_map.meta["title"]

func _process(delta):
	pass
