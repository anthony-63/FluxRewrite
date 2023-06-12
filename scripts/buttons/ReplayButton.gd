extends Node

signal selected(replay_data)

var replay_data = {}

func update(data):
	replay_data = data
	
	if not data.meta.artist == "":
		$SongName.text = "%s - %s" % [data.meta.artist, data.meta.title]
	else:
		$SongName.text = data.meta.title
		
	$DateTime.text = data.datetime
	
func _on_pressed():
	selected.emit(replay_data)
