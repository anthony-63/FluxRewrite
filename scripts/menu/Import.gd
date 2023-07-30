extends Node

func _on_import_from_txt_data_pressed():
	get_tree().change_scene_to_file("res://scenes/TxtDataImporter.tscn")

var eflux_file = ""

var efluxfiledialog = NativeFileDialog.new()
var fluxfiledialog = NativeFileDialog.new()

func _ready():
	efluxfiledialog.connect("file_selected", _eflux_file_selected)
	fluxfiledialog.connect("file_selected", _flux_file_selected)
	$VBoxContainer/MergeEFlux.connect("pressed", show_dialogs)
	add_child(efluxfiledialog)
	add_child(fluxfiledialog)

func show_dialogs():
	efluxfiledialog.set_title("Pick a .eflux event file")
	efluxfiledialog.add_filter("*.eflux", "Flux event file(*.eflux)")
	efluxfiledialog.file_mode = NativeFileDialog.FILE_MODE_OPEN_FILE
	efluxfiledialog.show()

func _eflux_file_selected(path: String):
	fluxfiledialog.set_title("Pick a .flux map file")
	fluxfiledialog.add_filter("*.flux", "Flux map file(*.flux)")
	fluxfiledialog.file_mode = NativeFileDialog.FILE_MODE_OPEN_FILE
	eflux_file = path
	fluxfiledialog.show()

func _flux_file_selected(path: String):
	FluxEvents.embed_events(eflux_file, path)