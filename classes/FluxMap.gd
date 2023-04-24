extends Node

var meta = {}
var jackets = {}
var audio_data = [] 
var difficulties = {}
var id = ""
const very_cool_seperator = "Ξζξ"

class FluxNoteRawData:
	var x: float
	var y: float
	var time: int
	
func load_from_path(path):
	id = path	
	var file = FileAccess.open("user://maps/%s" % path, FileAccess.READ)
	var file_txt_a = file.get_as_text()
	var file_txt = file_txt_a.substr(1).split(very_cool_seperator)
	
	var version = file.get_8()
	if version != 2:
		push_error("Invalid map version... skipping")
		return
		
	meta = JSON.parse_string(file_txt[0])
	
	difficulties = JSON.parse_string(file_txt[1])
	if meta["has_jacket"]:
		jackets = JSON.parse_string(file_txt[2])
		
	audio_data = file_txt[3].to_utf8_buffer()
	
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
	
	var _jackets = {}
	output.store_string(" " + very_cool_seperator)
	
	for i in txt_data.split(",").slice(1):
		var note_data = i.replace("\r", "").replace("\n", "").split("|")
		diffs["default"].append({
			"x": float(note_data[0]),
			"y": float(note_data[1]),
			"ms": int(note_data[2]),
		})
	
	output.store_string(JSON.stringify(diffs))
	output.store_string(very_cool_seperator)

	var audio_bytes = FileAccess.get_file_as_bytes(audio_path)
	output.store_buffer(audio_bytes)
