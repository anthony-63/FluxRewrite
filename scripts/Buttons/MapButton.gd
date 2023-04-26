extends Node

signal selected(map_data)

var map_data = {}

func update(data):
	map_data = data
	
	$SongName.text = "%s - %s" % [data.meta.artist, data.meta.title]
	$Mapper.text = "%s - %s" % [data.meta.mapper, Flux.ms_to_min_sec_str(data.diffs.default[-1].ms)]
	
	$Diff.text = "default"

func _on_pressed():
	selected.emit(map_data)
