extends Node

var thread: Thread = Thread.new()

var finished_loading_maps = false
var finished_loading_settings = false
var finished_loading_notesets = false

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

func load_notesets():
	Flux.notesets = []
	var noteset_dir = DirAccess.open("user://notesets")
	if noteset_dir:
		for dir in noteset_dir.get_directories():
			if not dir.is_empty():
				FluxNoteset.load_noteset(dir)
			else:
				print("Noteset dir '%s' is empty, Skipping..." % dir)
	else:
		var user_dir = DirAccess.open("user://")
		user_dir.make_dir("notesets")
		
		noteset_dir = DirAccess.open("user://notesets")
		noteset_dir.make_dir("default")
		
		noteset_dir.copy("res://prefabs/user/default_noteset/1.png", "user://notesets/default/1.png")	
		noteset_dir.copy("res://prefabs/user/default_noteset/2.png", "user://notesets/default/2.png")	
		
		load_notesets()
	finished_loading_notesets = true
func load_settings():
	if FileAccess.file_exists("user://settings.json"):
		var f = FileAccess.get_file_as_string("user://settings.json")
		Flux.settings = JSON.parse_string(f)
	finished_loading_settings = true


func _process(delta):
	thread.start(load_settings)
	thread.wait_to_finish()
	thread.start(load_maps)
	thread.wait_to_finish()
	thread.start(load_notesets)
	thread.wait_to_finish()
	
	if finished_loading_maps and finished_loading_settings and finished_loading_notesets:
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")

