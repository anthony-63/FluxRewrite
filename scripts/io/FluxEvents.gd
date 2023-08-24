extends Node

enum EventTypes {
	GridSize,
	GridTranslation,
	CameraZoom,
	CameraRotation,
	Flash,
	None, # Should only get selected during an error
}

func parse_all_events(event_string: String):
	var events = []
	for i in event_string.split("\n"):
		events.append(parse_event_line(i))
	return events

func parse_event_line(event_line: String):
	var event_split = event_line.split("|")
	
	var event_ms: int = int(event_split[0])

	var event_type: EventTypes = EventTypes.None
	match event_split[1]:
		"GS": event_type = EventTypes.GridSize
		"GT": event_type = EventTypes.GridTranslation
		"CZ": event_type = EventTypes.CameraZoom
		"CR": event_type = EventTypes.CameraRotation        
		"EF": event_type = EventTypes.Flash
		_: event_type = EventTypes.None
	
	var event_args: Array = []

	if event_type == EventTypes.GridSize:
		event_args = Array(event_split[2].split("x"))
	else:
		event_args = Array(event_split[2].split(","))

	return {
		"ms": event_ms,
		"type": event_type,
		"args": event_args,
	}


func embed_events(file_path: String, map_path: String):
	var event_string = FileAccess.get_file_as_string(file_path)
	
	var map_bytes = FileAccess.get_file_as_bytes(map_path)
	if map_bytes[0] & 0xf > 1:
		print("Already embedded")
		return
	map_bytes[0] = map_bytes[0] | 0x10
	FileAccess.open(map_path, FileAccess.WRITE).store_buffer(map_bytes)
	
	var map_file = FileAccess.open(map_path, FileAccess.READ_WRITE)
	map_file.seek_end()
	map_file.store_string(FluxMap.very_cool_seperator)	
	map_file.store_string(JSON.stringify(parse_all_events(event_string), "", false))
