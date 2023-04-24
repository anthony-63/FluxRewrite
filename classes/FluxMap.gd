extends Node

var meta = {}
var jackets = {}
var audio_data = [] 
var diffs = {}
const very_cool_seperator = "Ξζξ"

class FluxNoteRawData:
	var x: float
	var y: float
	var time: int
	
func get_start_of_audio_buffer(f_txt: String):
	var a = f_txt.find(very_cool_seperator)
	var b = f_txt.find(very_cool_seperator, a + 1)
	var c = f_txt.find(very_cool_seperator, b + 1)
	return c
	
func load_from_path(path):
	var file = FileAccess.open("user://maps/%s" % path, FileAccess.READ)
	var file_txt_a = file.get_as_text()
	var file_txt = file_txt_a.substr(1).split(very_cool_seperator)
	
	var version = file.get_8()
	if version != 2:					
		push_error("Invalid map version... skipping")
		return
		
	var file_bytes = file.get_buffer(file.get_length() - 1)
	
	meta = JSON.parse_string(file_txt[0])
	print(file_txt[3])
	diffs = JSON.parse_string(file_txt[1])
	if meta["has_jacket"]:
		jackets = JSON.parse_string(file_txt[2])
		
	audio_data = file_bytes.slice(get_start_of_audio_buffer(file_txt_a))
	
	print(meta["title"] + " " + meta["artist"] + " " + meta["mapper"] + " " + meta["id"])
	
	Flux.maps.append(self)
	
func conv_from_txt_audio(txt_data, audio_path, title, artist, mapper, id, jacket_path = ""):
#	var audio_data = FileAccess.get_file_as_bytes(audio_path)
	var output = FileAccess.open("user://maps/%s.flux" % id, FileAccess.WRITE)
	
	output.store_8(2) # version
	
	var meta = {}
	meta["title"] = title
	meta["artist"] = artist
	meta["mapper"] = mapper
	meta["id"] = id
	meta["has_jacket"] = false # jackets are not supported yet
	output.store_string(JSON.stringify(meta))
	
	output.store_string(very_cool_seperator)
	
	var diffs = {}
	diffs["default"] = []
	
	for i in txt_data.split(",").slice(1):
		var note_data = i.replace("\r", "").replace("\n", "").split("|")
		diffs["default"].append({
			"x": float(note_data[0]),
			"y": float(note_data[1]),
			"ms": int(note_data[2]),
		})
	output.store_string(JSON.stringify(diffs))
	output.store_string(very_cool_seperator)
	
	var _jackets = {}
	output.store_string(" " + very_cool_seperator)
	
	var audio_bytes = FileAccess.get_file_as_bytes(audio_path)
	output.store_buffer(audio_bytes)
