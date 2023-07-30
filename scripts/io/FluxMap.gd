extends Node

var meta: Dictionary
var jackets: Dictionary
var audio_stream: AudioStream
var diffs: Dictionary
var path: String
var end_time: int
const very_cool_seperator: String = "Ξζξ"
var version: int
var events: Dictionary
var has_events: bool

var combined_map_data: Dictionary = {}

func get_start_of_audio_buffer(f_txt: String):
	var a: int = f_txt.find(very_cool_seperator)
	var b: int = f_txt.find(very_cool_seperator, a + 1)
	var c: int = f_txt.find(very_cool_seperator, b + 1)
	return c + 12

func load_data(dict: Dictionary):
	var file_txt_a: String = FileAccess.get_file_as_string("user://maps/%s" % dict.path)
	var file_txt: PackedStringArray = file_txt_a.substr(1).split(very_cool_seperator)
	var file_bytes: PackedByteArray = FileAccess.get_file_as_bytes("user://maps/%s" % dict.path)

	dict.diffs = JSON.parse_string(file_txt[1])

	if dict.has_events: dict.events = JSON.parse_string(file_txt[4])

	if meta["has_jacket"]:
		dict.jackets = JSON.parse_string(file_txt[2])
		
	var audio_bytes: PackedByteArray = file_bytes.slice(get_start_of_audio_buffer(file_txt_a))
	
	var format: Flux.AudioFormat = Flux.get_audio_format(audio_bytes)
	match format:
		Flux.AudioFormat.WAV:
			dict.audio_stream = AudioStreamWAV.new()
			dict.audio_stream.data = audio_bytes
		Flux.AudioFormat.OGG:
			dict.audio_stream = AudioStreamOggVorbis.new()
			dict.audio_stream.packet_sequence = Flux.get_ogg_packet_sequence(audio_bytes)
		Flux.AudioFormat.MP3:
			dict.audio_stream = AudioStreamMP3.new()
			dict.audio_stream.data = audio_bytes
		_:
			print("File: %s, Invalid format. Magic: %s" % [path, audio_bytes.slice(0,3)])
			return

func load_from_path(path_: String, map_cache: Dictionary):
	path = path_
	if path in map_cache.keys():
		meta = map_cache[path].meta
		end_time = map_cache[path].end_time
		version = map_cache[path].version
	else:
		var file_txt_a: String = FileAccess.get_file_as_string("user://maps/%s" % path)
		var file_txt: PackedStringArray = file_txt_a.substr(1).split(very_cool_seperator)
		
		var file: FileAccess = FileAccess.open("user://maps/%s" % path, FileAccess.READ)
		
		var version_ev = file.get_8()
		version = (version_ev >> 4) & 0xf
		has_events = bool(version_ev & 0xf)

		if version < 2 and version > 3:
			push_error("Invalid map version... skipping")
			return
		file.close()
		meta = JSON.parse_string(file_txt[0])
		diffs = JSON.parse_string(file_txt[1])
		if len(diffs.default) < 1:
			end_time = 0
		else: end_time = diffs.default[-1].ms

	combined_map_data = {
		"meta": meta,
		"diffs": {},
		"path": path,
		"end_time": end_time,
		"jackets": {},
		"audio_stream": null,
		"version": version,
		"has_events": has_events,
	}

	Flux.maps.append(combined_map_data)

func sspm_to_flux(sspm_path, cmd):
	var file: FileAccess = FileAccess.open("user://maps/%s.flux" % cmd.meta.id, FileAccess.WRITE)
	print("converting: %s" % sspm_path)
	file.store_8(2) # version
	file.store_string(JSON.stringify(cmd.meta))
	file.store_string(very_cool_seperator)
	file.store_string(JSON.stringify(cmd.diffs))
	file.store_string(very_cool_seperator)
	var _jackets: Dictionary = {}
	file.store_string(" " + very_cool_seperator)
	file.store_buffer(combined_map_data.audio_buffer)
	DirAccess.remove_absolute("user://maps/%s" % sspm_path)
	
func conv_from_txt_audio(txt_data, audio_path, title, artist, mapper, id, _jacket_path = ""):
#	var audio_data = FileAccess.get_file_as_bytes(audio_path)
	var output: FileAccess = FileAccess.open("user://maps/%s.flux" % id, FileAccess.WRITE)
	
	output.store_8(2) # version
	
	var meta_: Dictionary = {}
	meta_["title"] = title
	meta_["artist"] = artist
	meta_["mapper"] = mapper
	meta_["id"] = id
	meta_["has_jacket"] = false # jackets are not supported yet
	output.store_string(JSON.stringify(meta_))
	
	output.store_string(very_cool_seperator)
	
	var diffs_: Dictionary = {}
	diffs_["default"] = []
	
	for i in txt_data.split(",").slice(1):
		var note_data: String = i.replace("\r", "").replace("\n", "").split("|")
		diffs_["default"].append({
			"x": float(note_data[0]),
			"y": float(note_data[1]),
			"ms": int(note_data[2]),
		})
	output.store_string(JSON.stringify(diffs_))
	output.store_string(very_cool_seperator)
	
	var _jackets: Dictionary = {}
	output.store_string(" " + very_cool_seperator)
	
	var audio_bytes: PackedByteArray = FileAccess.get_file_as_bytes(audio_path)
	output.store_buffer(audio_bytes)
