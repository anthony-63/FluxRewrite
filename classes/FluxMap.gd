extends Node

var meta = {}
var audio_data = []
var img_data = [] 
var difficulties = {}
var good_map = false
var map_path = ""

func read_u16_flipped(f):
	var n = f.get_8()
	var nn = f.get_8()
	
	return n | nn

func load_from_path(path):
	map_path = "user://maps/%s" % path
	var f = FileAccess.open(map_path, FileAccess.READ)
	var magic = f.get_buffer(4).get_string_from_utf8()
	if magic != "FLUX":
		Flux.maps.push_back(self)
		return
	
	var vers = f.get_8()
	if vers != 1:
		Flux.maps.push_back(self)
		return
	
	var meta_count = read_u16_flipped(f)
	
	for i in range(0, meta_count):
		var meta_val_len = read_u16_flipped(f)
		var meta_val = ""
		for v in range(0, meta_val_len):
			meta_val += char(f.get_8())
			
		var meta_key_len = read_u16_flipped(f)
		var meta_key = ""
		for v in range(0, meta_key_len):
			meta_key += char(f.get_8())
		
		
		meta_key = meta_key.replace("\r", "").replace("\n", "")
		meta_val = meta_val.replace("\r", "").replace("\n", "")
		
		# ???? why do i have to do this wtf, but it works for nowhttps://i.imgur.com/wwcbYVo.png
		
		if meta_key == "mapper":
			meta_key = "song_name"
		elif meta_key == "song_name":
			meta_key = "mapper"
		
		meta[meta_key] = meta_val
		
	Flux.maps.push_back(self)
