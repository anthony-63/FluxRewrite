extends Node

var thread: Thread = Thread.new()

var finished_loading_maps = false
var finished_loading_settings = false

func load_maps():
	Flux.maps = []
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
	finished_loading_maps = true

func load_settings():
	if FileAccess.file_exists("user://settings.json"):
		var f = FileAccess.get_file_as_string("user://settings.json")
		Flux.settings = JSON.parse_string(f)
	finished_loading_settings = true
func _process(delta):
	thread.start(load_maps)
	thread.wait_to_finish()
	thread.start(load_settings)
	thread.wait_to_finish()
	if finished_loading_maps and finished_loading_settings:
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")
