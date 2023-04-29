extends Node

@onready var note_scene = preload("res://scenes/NoteSprite.tscn")

var note_index = 0

func _ready():
	pass
	
func _process(delta):
	if Flux.current_map == {}:
		return
	
	if note_index + 1 >= len(Flux.current_map.diffs.default):
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")
		
	if Flux.time_manager.current_time > Flux.current_map.diffs["default"][note_index]["ms"]:
		var ndata = Flux.current_map.diffs["default"][note_index]
		var note = note_scene.instantiate()
		note.spawn_time = ndata["ms"] - ((Flux.settings["note"]["approach_time"] * 10000.0) * Flux.mods["speed"])
		note.index = note_index
		add_child(note)
		note_index += 1
	for child in get_children():
		child.update(Flux.time_manager.current_time)
