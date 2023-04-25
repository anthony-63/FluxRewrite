extends Node

var thread: Thread = Thread.new()

var finished = false

func load_maps():
	var map_dir = DirAccess.open("user://maps")
	if map_dir:
		var files = map_dir.get_files()
		for map_path in files:
			if not map_path.ends_with(".flux"):
				map_dir.get_next()
				continue
				
			$FluxImage/CurrentMap.text = map_path
			
			FluxMap.load_from_path(map_path)
	else:
		var user_dir = DirAccess.open("user://")
		user_dir.make_dir("maps")
	finished = true

func _ready():
	load_maps()
	Flux.set_current_map("pryrule-dashie-my_bad")
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
