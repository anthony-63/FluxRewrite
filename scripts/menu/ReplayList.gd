extends Node

var replay_button_data: Array = []

func _ready():
	$ReplayScrollVbox/ReplayButton.visible = false
	update_replays()
	
func _process(_d):
	for child in $ReplayScrollVbox.get_children():
		if child.name.begins_with("ReplayButton_"):
			if $ReplayScrollVbox/Search.text == "":
				child.visible = true
			elif child.replay_data.meta.title.findn($ReplayScrollVbox/Search.text) != -1:
				child.visible = true
			elif child.replay_data.meta.mapper.findn($ReplayScrollVbox/Search.text) != -1:
				child.visible = true
			elif child.replay_data.meta.artist.findn($ReplayScrollVbox/Search.text) != -1:
				child.visible = true
			elif child.replay_data.datetime.findn($ReplayScrollVbox/Search.text) != -1:
				child.visible = true
			else:
				child.visible = false

func update_replays():
	print("Updating replays...")
	for child in $ReplayScrollVbox.get_children():
		if child.name.begins_with("ReplayButton_"):
			child.queue_free()
			if child in $ReplayScrollVbox.get_children():
				child.queue_free()
	replay_button_data = []
	
	var replay_dir: DirAccess = DirAccess.open("user://replays")
	var replay_files: PackedStringArray = replay_dir.get_files()
	
	var replays_info: Array = []
	
	for file in replay_files:
		if not file.ends_with(".rflux"):
			continue
		print(file)
		
		var f: FileAccess = FileAccess.open("user://replays/" + file, FileAccess.READ)
		
		var MAGIC: Array = [] 
		MAGIC.append(f.get_8())
		MAGIC.append(f.get_8())
		MAGIC.append(f.get_8())
		MAGIC.append(f.get_8())
		MAGIC.append(f.get_8())
		
		if MAGIC != [0x52, 0x46, 0x4C, 0x55, 0x58]:
			print("invalid replay file: " + file)
			continue
		
		replays_info.append({"meta": ReplayManager.get_metadata(file).meta, "datetime":  ReplayManager.get_metadata(file).datetime, "file": file})
	
	replays_info.reverse()
	
	var i = 0
	for data in replays_info:
		var button: Button = $ReplayScrollVbox/ReplayButton.duplicate()
		button.name = "ReplayButton_%d" % i
		button.visible = false
		button.update(data)
		i += 1
		$ReplayScrollVbox.add_child(button)

#func _on_reload_map_list_pressed():
#	Flux.reload_game()


func _on_replay_button_selected(replay_data):
	Flux.play_replay(replay_data)
