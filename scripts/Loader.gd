extends Node

var thread: Thread = Thread.new()

var finished_loading_maps = false
var finished_loading_settings = false
var finished_loading_notesets = false

func load_maps():
	# Clear maps so they dont duplicate when reloading
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
	load_sspms()
	finished_loading_maps = true
	
func load_notesets():
	Flux.notesets = {}
	FluxNoteset.load_default_noteset()
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
		load_notesets()
	finished_loading_notesets = true

func load_sspms():
	var map_dir = DirAccess.open("user://sspm")
	if map_dir:
		var files = map_dir.get_files()
		for map_path in files:
			if not map_path.ends_with(".sspm"):
				map_dir.get_next()
				continue
				
			$FluxImage/CurrentMap.text = map_path
			
			Sspm2Flux.flux_from_sspm(map_path)
	else:
		var user_dir = DirAccess.open("user://")
		user_dir.make_dir("sspm")

func validate_settings(settings_dict: Dictionary):
	for cat in Flux.default_settings.keys():
		if not cat in settings_dict:
			print("Invalid cat: %s" % cat)
			return false
		if typeof(settings_dict[cat]) == TYPE_DICTIONARY:
			for setting in settings_dict[cat].keys():
				if not setting in settings_dict[cat]:
					print("Invalid setting %s in cat %s" % [setting, cat])
					return false
		
	return true

func load_settings():
	if FileAccess.file_exists("user://settings.json"):
		var f = FileAccess.get_file_as_string("user://settings.json")
		var settings_dict = JSON.parse_string(f)
		if validate_settings(settings_dict):
			Flux.settings = settings_dict
			Flux.settings.debug.show_note_hitbox = Flux.default_settings.debug.show_note_hitbox
			Flux.settings.debug.show_cursor_hitbox = Flux.default_settings.debug.show_cursor_hitbox
			
		else:
			print("Invalid settings file, using default.")
	finished_loading_settings = true

func _process(_delta):
	# the whole point of this was to render the loading screen at the same time
	# it doesnt.
	load_settings()
	load_maps()
	load_notesets()

	FluxNoteset.load_default_noteset()
	
	# This is also probably a bad way to do this. 
	if finished_loading_maps and finished_loading_settings and finished_loading_notesets:
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")

