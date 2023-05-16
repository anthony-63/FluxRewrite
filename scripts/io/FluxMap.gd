extends Node

var meta = {}
var jackets = {}
var audio_stream = [] 
var diffs = {}
const very_cool_seperator = "Ξζξ"

enum AudioFormat {
	OGG,
	WAV,
	MP3,
	UNKNOWN,
}

var combined_map_data = {}

func get_start_of_audio_buffer(f_txt: String):
	var a = f_txt.find(very_cool_seperator)
	var b = f_txt.find(very_cool_seperator, a + 1)
	var c = f_txt.find(very_cool_seperator, b + 1)
	return c

static func get_audio_format(buffer:PackedByteArray):
	if buffer.slice(0,4) == PackedByteArray([0x4F,0x67,0x67,0x53]): return AudioFormat.OGG

	if (buffer.slice(0,4) == PackedByteArray([0x52,0x49,0x46,0x46])
	and buffer.slice(8,12) == PackedByteArray([0x57,0x41,0x56,0x45])): return AudioFormat.WAV

	if (buffer.slice(0,2) == PackedByteArray([0xFF,0xFB])
	or buffer.slice(0,2) == PackedByteArray([0xFF,0xF3])
	or buffer.slice(0,2) == PackedByteArray([0xFF,0xFA])
	or buffer.slice(0,2) == PackedByteArray([0xFF,0xF2])
	or buffer.slice(0,3) == PackedByteArray([0x49,0x44,0x33])): return AudioFormat.MP3

	return AudioFormat.UNKNOWN

# stolen from kerm by anthony63 :troll:
func get_ogg_packet_sequence(data:PackedByteArray):
	var packets = []
	var granule_positions = []
	var sampling_rate = 0
	var pos = 0
	while pos < data.size():
		# Parse the Ogg packet header
		var header = data.slice(pos, pos + 27)
		pos += 27
		# Check the capture pattern
		if header.slice(0, 4) != "OggS".to_ascii_buffer():
			break
		# Get the packet type
		var packet_type = header.decode_u8(5)
#		print("packet type: %s" % packet_type)
		# Get the granule position
		var granule_position = header.decode_u64(6)
#		print("granule position: %s" % granule_position)
		granule_positions.append(granule_position)
		# Get the page sequence number
#		var sequence_number = header.decode_u32(18)
#		print("sequence number: %s" % sequence_number)
		# Get the segment table
		var segment_table_length = header.decode_u8(26)
#		print("segment table length: %s" % segment_table_length)
		var segment_table = data.slice(pos, pos + segment_table_length)
		pos += segment_table_length
		# Get the packet data
		var packet_data = []
		var appending = false
		for i in range(segment_table_length):
			var segment_size = segment_table.decode_u8(i)
			var segment = data.slice(pos, pos + segment_size)
			if appending: packet_data.back().append_array(segment)
			else: packet_data.append(segment)
			appending = segment_size == 255
			pos += segment_size
		# Add the packet data to the array
		packets.append(packet_data)
		if sampling_rate == 0 and packet_type == 2:
			var info_header = packet_data[0]
			if info_header.slice(1, 7).get_string_from_ascii() != "vorbis":
				break
			sampling_rate = info_header.decode_u32(12)
	var packet_sequence = OggPacketSequence.new()
	packet_sequence.sampling_rate = sampling_rate
	packet_sequence.granule_positions = granule_positions
	packet_sequence.packet_data = packets
	return packet_sequence

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
