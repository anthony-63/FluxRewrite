extends Node

var meta = {}
var jackets = {}
var audio_stream: AudioStream
var diffs = {}
const very_cool_seperator = "Ξζξ"

var combined_map_data = {}

func get_start_of_audio_buffer(f_txt: String):
	var a = f_txt.find(very_cool_seperator)
	var b = f_txt.find(very_cool_seperator, a + 1)
	var c = f_txt.find(very_cool_seperator, b + 1)
	return c + 12

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
	
	var format = Flux.get_audio_format(audio_bytes)
	match format:
		Flux.AudioFormat.WAV:
			audio_stream = AudioStreamWAV.new()
			audio_stream.data = audio_bytes
		Flux.AudioFormat.OGG:
			audio_stream = AudioStreamOggVorbis.new()
			audio_stream.packet_sequence = Flux.get_ogg_packet_sequence(audio_bytes)
		Flux.AudioFormat.MP3:
			audio_stream = AudioStreamMP3.new()
			audio_stream.data = audio_bytes
		_:
			print("File: %s, Invalid format. Magic: %s" % [path, audio_bytes.slice(0,3)])
			return
	
	combined_map_data = {
		"meta": meta,
		"diffs": diffs,
		"jackets": jackets,
		"audio_stream": audio_stream,
	}

	Flux.maps.append(combined_map_data)

func sspm_to_flux(sspm_path, combined_map_data):
	var file = FileAccess.open("user://maps/%s.flux" % combined_map_data.meta.id, FileAccess.WRITE)
	print("converting: %s" % sspm_path)
	file.store_8(2) # version
	file.store_string(JSON.stringify(combined_map_data.meta))
	file.store_string(very_cool_seperator)
	file.store_string(JSON.stringify(combined_map_data.diffs))
	file.store_string(very_cool_seperator)
	var _jackets = {}
	file.store_string(" " + very_cool_seperator)
	file.store_buffer(combined_map_data.audio_buffer)
	DirAccess.remove_absolute("user://maps/%s" % sspm_path)
	
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
