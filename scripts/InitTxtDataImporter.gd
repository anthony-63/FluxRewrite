extends Node

func _ready():
	pass


func _on_open_mp_3_file_pressed():
	$FileDialog.popup_centered(Vector2(get_window().size.x / 2.0, get_window().size.y / 2.0))

func _on_file_dialog_file_selected(path):
	$AudioPath.text = path

func _on_convert_button_pressed():
	if $MapTxtData.text == "":
		$ErrLabel.text = "Map data empty"
		return
	if $AudioPath.text == "":
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
