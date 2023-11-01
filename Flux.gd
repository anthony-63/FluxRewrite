extends Node

var maps: Array = []
var notesets: Dictionary = {}
var cursorsets: Dictionary = {}
var current_map: Dictionary = {}
var transition_time: float = 1
var fullscreen: bool = false
var update_selected_map: bool = false
var cursor_pos: Vector3 = Vector3(0, 0, 0)
var replay_poss: Array = []
var replaying: bool = false
var replay_file: FileAccess = null
var spinning: bool = false

const version_string: String = "FluxRewrite v0.5 ALPHA"

var map_finished_info: Dictionary = {
	"max_combo": 0,
	"misses": 0,
	"accuracy": 0,
	"passed": false,
	"played": false,
}

var game_stats: Dictionary = {
	"misses": 0,
	"hits": 0,
	"combo": 0,
	"max_combo": 0,
	
	"hp": 0.0,
	"max_hp": 5.0,
	"hp_per_hit": 0.5,
	"hp_per_miss": 1.0,
}

var default_settings: Dictionary = {
	"note": {
		"ar": 10.0, # m/s
		"sd": 4.0, # m
		"fd": 0.0,
		"approach_time": 0.0, # s
		"fade": false,
	},
	"debug": {
		"show_note_hitbox": false,
		"show_cursor_hitbox": true,
	},
	"game": {
		"hitwindow": 58, # ms
		"hitbox": 1.14, # m
		"cursor_hitbox": 0.2526,
		"wait_time": 1.5, # s
		"parallax": 0.25,
		"spin": false,
		"replay": true,
	},
	"cursor": {
		"sensitivity": 1.0, # m/s
		"scale": 1.9, # m
		"drift": false,
	},
	"ui": {
		"enable_ruwo": true,
		"debug": false,
	},
	"sets": {
		"noteset": "default",
		"cursorset": "default",
	},
	"audio": {
		"music_volume": 0.5, # %
	}
}

var settings: Dictionary = default_settings
var tmp_settings: Dictionary = settings

var mods: Dictionary = {
	"speed": 1.0, # %
	"seek": 0, # s
	"endseek": -1, # s
	"no_fail": false,
	"visual_map": false
}

var tmp_mods: Dictionary = mods

func _ready():
#	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if fullscreen: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen = !fullscreen

func get_setting(category:String, setting:String):
	if setting in settings.get(category):
		return settings.get(category).get(setting)
	else:
		return default_settings.get(category).get(setting)

func reload_game():
	get_tree().change_scene_to_file("res://scenes/Loading.tscn")

func reload_game_stylish():
	if $"..".has_node("Transition"):
		$"../Transition".transition_out()
		await get_tree().create_timer(transition_time).timeout
		get_tree().change_scene_to_file("res://scenes/Loading.tscn")

func ms_to_min_sec_str(ms):
	var mins: int = int(float(ms) * 0.001) / 60
	var secs: int = int(float(ms) * 0.001) % 60
	return str(max(mins, 0.0)) + ":" + ("%02d" % max(secs, 0.0))

func play_replay(replay_data, scr):
	var file_text: String = FileAccess.get_file_as_string("user://replays/" + replay_data.file)
	var a: int = file_text.find("Ξζξ")
	var b: int = file_text.find("Ξζξ", a + 1)
	replay_file = FileAccess.open("user://replays/" + replay_data.file, FileAccess.READ)
	replay_file.seek(b + 9)
	
	var m: Dictionary = {}
	for map in Flux.maps:
		if map.meta.id == replay_data.meta.id: m = map
	
	if not FileAccess.file_exists("user://maps/%s.flux" % replay_data.meta.id):
		NotificationService.show_notification(scr, NotificationType.Ok, "Failed to load replay", "Map ID does not exist: %s" % replay_data.meta.id)
		return
	
	replaying = true
	
	Flux.spinning = bool(replay_file.get_8()) # spin
	Flux.mods.no_fail = bool(replay_file.get_8()) # no fail
	
	Flux.mods.speed = replay_file.get_float() # get speed of the map
	Flux.settings.note.ar = replay_file.get_float()
	Flux.settings.note.sd = replay_file.get_float()
	
	print("speed: " + str(Flux.mods.speed) + "\nar: " + str(Flux.settings.note.ar) + "\nsd: " + str(Flux.settings.note.sd))

	Flux.current_map = m
	FluxMap.load_data(Flux.current_map)
	
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func get_map_len_str(map):
	var map_len: String = "err:err"
	if map.end_time != 0:
		map_len = Flux.ms_to_min_sec_str(map.end_time)
	return map_len
	
enum AudioFormat {
	OGG,
	WAV,
	MP3,
	UNKNOWN,
}

# got this from kermeet. Thanks :3
func get_ogg_packet_sequence(data:PackedByteArray):
	var packets: Array = []
	var granule_positions: Array = []
	var sampling_rate: int = 0
	var pos: int  = 0
	while pos < data.size():
		var header = data.slice(pos, pos + 27)
		pos += 27
		if header.slice(0, 4) != "OggS".to_ascii_buffer():
			break

		var packet_type = header.decode_u8(5)
		var granule_position = header.decode_u64(6)

		granule_positions.append(granule_position)

		var segment_table_length = header.decode_u8(26)

		var segment_table = data.slice(pos, pos + segment_table_length)
		pos += segment_table_length

		var packet_data = []
		var appending = false
		for i in range(segment_table_length):
			var segment_size = segment_table.decode_u8(i)
			var segment = data.slice(pos, pos + segment_size)
			if appending: packet_data.back().append_array(segment)
			else: packet_data.append(segment)
			appending = segment_size == 255
			pos += segment_size

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

func get_audio_format(buffer:PackedByteArray):
	if buffer.slice(0,4) == PackedByteArray([0x4F,0x67,0x67,0x53]): return AudioFormat.OGG

	if (buffer.slice(0,4) == PackedByteArray([0x52,0x49,0x46,0x46])
	and buffer.slice(8,12) == PackedByteArray([0x57,0x41,0x56,0x45])): return AudioFormat.WAV

	if (buffer.slice(0,2) == PackedByteArray([0xFF,0xFB])
	or buffer.slice(0,2) == PackedByteArray([0xFF,0xF3])
	or buffer.slice(0,2) == PackedByteArray([0xFF,0xFA])
	or buffer.slice(0,2) == PackedByteArray([0xFF,0xF2])
	or buffer.slice(0,3) == PackedByteArray([0x49,0x44,0x33])): return AudioFormat.MP3

	return AudioFormat.UNKNOWN
