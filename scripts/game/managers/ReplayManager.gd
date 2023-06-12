extends Node3D

var curr_file: FileAccess

const very_cool_seperator = "Ξζξ"

func save_stamp(cursor_loc):
	if not curr_file: return
	curr_file.store_float(cursor_loc.x)
	curr_file.store_float(cursor_loc.y)

func get_metadata(filename):
	var f = FileAccess.get_file_as_string("user://replays/" + filename)
	var ff = JSON.parse_string(f.split(very_cool_seperator)[1])
	return ff

func start_replay_save():
	var time = Time.get_datetime_dict_from_system()
	var curr_fname = str(time.day) + "-" + str(time.month) + "-" + str(time.year) + "_" + str(time.hour) + "-" + str(time.minute) + "-" + str(time.second) + "_" + Flux.current_map.meta.id + "_.rflux"
	curr_file = FileAccess.open("user://replays/" + curr_fname, FileAccess.WRITE)
	if curr_file == null:
		print("failed to open replay file: " + curr_fname)
	curr_file.store_8(0x52)
	curr_file.store_8(0x46)
	curr_file.store_8(0x4C)
	curr_file.store_8(0x55)
	curr_file.store_8(0x58)
	curr_file.store_string(very_cool_seperator)
	curr_file.store_string(JSON.stringify({"meta": Flux.current_map.meta, "datetime": str(time.month) + "-" + str(time.day) + "-" + str(time.year) + " / " + str(time.hour) + ":" + str(time.minute) }))
	curr_file.store_string(very_cool_seperator)

	if Flux.get_setting("game", "spin"):
		curr_file.store_8(1)
	else:
		curr_file.store_8(0)
	
	curr_file.store_float(Flux.mods.speed)
	curr_file.store_float(Flux.get_setting("note", "ar"))
	curr_file.store_float(Flux.get_setting("note", "sd"))

func end_replay():
	curr_file.close()
