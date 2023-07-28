extends Node

var thread: Thread = Thread.new()

signal finished_loading_maps
signal load_single_map

signal finished_loading_settings
signal load_single_setting

signal finished_loading_notesets
signal load_single_noteset

func _ready():
	pass

func load_maps():
	# Clear maps so they dont duplicate when reloading
	Flux.maps = []
	if not load_sspms():
		var user_dir: DirAccess = DirAccess.open("user://")
		user_dir.make_dir("maps")
		return
	
	var map_dir: DirAccess = DirAccess.open("user://maps")
	var files: PackedStringArray = map_dir.get_files()
	for map_path in files:
		if not map_path.ends_with(".flux"):
			continue
			
		$FluxImage/CurrentMap.text = map_path
		
		await FluxMap.load_from_path(map_path)
	
	finished_loading_maps.emit()
	
func load_notesets():
	Flux.notesets = {}
	FluxNoteset.load_default_noteset()
	var noteset_dir: DirAccess = DirAccess.open("user://notesets")
	if noteset_dir:
		for dir in noteset_dir.get_directories():
			if not dir.is_empty():
				FluxNoteset.load_noteset(dir)
			else:
				print("Noteset dir '%s' is empty, Skipping..." % dir)
	else:
		var user_dir: DirAccess = DirAccess.open("user://")
		user_dir.make_dir("notesets")
		load_notesets()
	finished_loading_notesets.emit()

func load_sspms():
	var map_dir: DirAccess = DirAccess.open("user://maps")
	if not map_dir:
		return false
	var files: PackedStringArray = map_dir.get_files()
	for map_path in files:
		if not map_path.ends_with(".sspm"):
			continue
			
		$FluxImage/CurrentMap.text = map_path
		
		Sspm2Flux.flux_from_sspm(map_path)
	return true
	
func validate_settings(settings_dict: Dictionary):
	for cat in Flux.default_settings.keys():
		if not cat in settings_dict.keys():
			print("Invalid cat: %s" % cat)
			return false

		for setting in settings_dict[cat].keys(): # fix this later
			if not setting in settings_dict[cat]:
				print("Invalid setting %s in cat %s" % [setting, cat])
				return false

	return true

func load_settings():
	if FileAccess.file_exists("user://settings.json"):
		var f: String = FileAccess.get_file_as_string("user://settings.json")
		var settings_dict: Dictionary = JSON.parse_string(f)
		if validate_settings(settings_dict):
			Flux.settings = settings_dict
			Flux.settings.debug.show_note_hitbox = Flux.default_settings.debug.show_note_hitbox
			Flux.settings.debug.show_cursor_hitbox = Flux.default_settings.debug.show_cursor_hitbox
		else:
			Flux.settings = Flux.default_settings # just to be sure
			print("Invalid settings file, using default.")
	
	finished_loading_settings.emit()

func _process(_delta):
	# the whole point of this was to render the loading screen at the same time
	# it doesnt.
	
	load_settings()
	load_maps()
	load_notesets()
	FluxNoteset.load_default_noteset()
	
	var replay_dir: DirAccess = DirAccess.open("user://replays")
	if not replay_dir:
		var user_dir: DirAccess = DirAccess.open("user://")
		user_dir.make_dir("replays")
	
	# This is also probably a bad way to do this. 
	await finished_loading_maps
	await finished_loading_notesets
	await finished_loading_settings
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

