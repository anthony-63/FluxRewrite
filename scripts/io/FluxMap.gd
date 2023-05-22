extends Node

var meta = {}
var jackets = {}
var audio_stream = [] 
var diffs = {}
const very_cool_seperator = "Ξζξ"

var combined_map_data = {}

func get_start_of_audio_buffer(f_txt: String):
	var a = f_txt.find(very_cool_seperator)
	var b = f_txt.find(very_cool_seperator, a + 1)
	var c = f_txt.find(very_cool_seperator, b + 1)
	return c

func load_from_path(path):
	var file_txt_a = FileAccess.get_file_as_string("user://maps/%s" % path)
	var file_txt = file_txt_a.substr(1).split(very_cool_seperator)
	
	var file = FileAccess.open("user://maps/%s" % path, FileAccess.READ)
	
	var version = file.get_8()
	if version != 2:
		push_error("Invalid map version... skipping")
		return
	file.close()
	
	var file_bytes = FileAccess.get_file_as_bytes("user://maps/%s" % path)
	
	meta = JSON.parse_string(file_txt[0])
	
	diffs = JSON.parse_string(file_txt[1])
	if meta["has_jacket"]:
		jackets = JSON.parse_string(file_txt[2])
		
	var audio_bytes = file_bytes.slice(get_start_of_audio_buffer(file_txt_a))
	
	audio_stream = AudioStreamMP3.new()
	audio_stream.data = audio_bytes
	
	print(meta["title"] + " " + meta["artist"] + " " + meta["mapper"] + " " + meta["id"])
	
	combined_map_data = {
		"artist_sep": true,
		"meta": meta,
		"diffs": diffs,
		"jackets": jackets,
		"audio_stream": audio_stream,
	}

	Flux.maps.append(combined_map_data)
	
func conv_from_txt_audio(txt_data, audio_path, title, artist, mapper, id, _jacket_path = ""):
#	var audio_data = FileAccess.get_file_as_bytes(audio_path)
	var output = FileAccess.open("user://maps/%s.flux" % id, FileAccess.WRITE)
	
	output.store_8(2) # version
	
	var meta_ = {}
	meta_["title"] = title
	meta_["artist"] = artist
	meta_["mapper"] = mapper
	meta_["id"] = id
	meta_["has_jacket"] = false # jackets are not supported yet
	output.store_string(JSON.stringify(meta_))
	
	output.store_string(very_cool_seperator)
	
	var diffs_ = {}
	diffs_["default"] = []
	
	for i in txt_data.split(",").slice(1):
		var note_data = i.replace("\r", "").replace("\n", "").split("|")
		diffs_["default"].append({
			"x": float(note_data[0]),
			"y": float(note_data[1]),
			"ms": int(note_data[2]),
		})
	output.store_string(JSON.stringify(diffs_))
	output.store_string(very_cool_seperator)
	
	var _jackets = {}
	output.store_string(" " + very_cool_seperator)
	
	var audio_bytes = FileAccess.get_file_as_bytes(audio_path)
	output.store_buffer(audio_bytes)
