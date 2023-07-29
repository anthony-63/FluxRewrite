extends Node

@onready var note_scene = preload("res://scenes/NoteSprite.tscn")

@export var note_index: int = 0
var spawn_new_notes: bool = true

func _ready():
	for note in Flux.current_map.diffs["default"]:
		note["st"] = note["ms"] - (Flux.get_setting("note", "approach_time") * Flux.mods["speed"]) * 1000.0
	
func _process(_delta):
	if Flux.current_map == {}:
		return
	if note_index + 1 >= len(Flux.current_map.diffs.default):
		spawn_new_notes = false
	
	var noteset: Array = Flux.notesets[Flux.get_setting("sets", "noteset")]
	
	if spawn_new_notes:
		if $"../AudioManager".current_time > Flux.current_map.diffs["default"][note_index].st:
			var ndata: Dictionary = Flux.current_map.diffs["default"][note_index]
			var note = note_scene.instantiate()
			note.spawn_time = Flux.current_map.diffs["default"][note_index].st
			note.index = note_index
			note.hittable = false
			note.ms = ndata.ms
			note.texture = noteset[note_index % len(noteset)]
			add_child(note)
			note_index += 1
		
	for child in get_children():
		child.update($"../AudioManager".current_time)
	

