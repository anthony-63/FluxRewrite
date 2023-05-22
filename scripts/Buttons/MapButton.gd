extends Node

signal selected(map_data)

var map_data = {}

func update(data):
	map_data = data
	
	if data.artist_sep:
		$SongName.text = "%s - %s" % [data.meta.artist, data.meta.title]
	else:
		$SongName.text = data.meta.title
		
	$Mapper.text = "%s - %s" % [data.meta.mapper, Flux.get_map_len_str(data)]
	
	$Diff.text = "none"

func _on_pressed():
	selected.emit(map_data)
