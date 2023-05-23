extends Node

func _ready():
	pass


func _on_open_mp_3_file_pressed():
	$AudioFileDialog.popup_centered(Vector2(get_window().size.x / 2.0, get_window().size.y / 2.0))

func _on_open_text_file_pressed():
	$TextFileDialog.popup_centered(Vector2(get_window().size.x / 2.0, get_window().size.y / 2.0))
	
func _on_file_dialog_file_selected(path):
	$AudioPath.text = path

func _on_text_file_dialog_file_selected(path):
	var f = FileAccess.get_file_as_string(path)
	$MapTxtData.text = f

func check_map_data(map_data: String):
	var splitted = map_data.split(",")
	if len(splitted) < 2:
		return false
	var splitted_noid = splitted.slice(1)
	for note in splitted_noid:
		var note_data = note.split("|")
		for nl in note_data:
			if not nl.is_valid_float() || not nl.is_valid_int():
				return false
		if len(note_data) != 3:
			return false
	return true

func _on_convert_button_pressed():
	if $MapTxtData.text == "":
		$ErrLabel.text = "Map data empty"
		return
	if !check_map_data($MapTxtData.text):
		$ErrLabel.text = "Invalid map data"
		return
	if $AudioPath.text == "Please select an audio file":
		$ErrLabel.text = "Audio file empty"
		return
	if $Artist.text == "":
		$ErrLabel.text = "Artist field empty"
		return
	if $Title.text == "":
		$ErrLabel.text = "Title field empty"
		return
	if $ID.text == "":
		$ErrLabel.text = "ID field empty"
		return
	if $Mapper.text == "":
		$ErrLabel.text = "Mapper field empty"
		return

	FluxMap.conv_from_txt_audio($MapTxtData.text, $AudioPath.text, $Title.text, $Artist.text, $Mapper.text, $ID.text)
