extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Changeables/Settings/SettingTypes/Note/AR.value = Flux.settings.note.ar
	$Changeables/Settings/SettingTypes/Note/SD.value = Flux.settings.note.sd
	$Changeables/Settings/SettingTypes/UI/EnableRuwoCheckbox.toggle_mode = Flux.settings.ui.enable_ruwo
	$Changeables/Settings/SettingTypes/Sound/MusicVolume.value = Flux.settings.audio.music_volume * 100.0
	$Changeables/Settings/SettingTypes/Cursor/CursorScale.value = Flux.settings.cursor.scale
	$Changeables/Settings/SettingTypes/Cursor/CursorSensitivity.value = Flux.settings.cursor.sensitivity
	$Changeables/Mods/Speed.value = Flux.mods.speed
	
	for noteset in Flux.notesets.keys():
		$Changeables/Settings/SettingTypes/Sets/Noteset.add_item(noteset)

func _process(_delta):
	Flux.settings.sets.noteset = $Changeables/Settings/SettingTypes/Sets/Noteset.get_item_text($Changeables/Settings/SettingTypes/Sets/Noteset.selected)
	if Flux.settings["ui"]["enable_ruwo"]:
		$Ruwo.show()
	else:
		$Ruwo.hide()

func update_at():
	Flux.settings["note"]["approach_time"] = Flux.settings["note"]["sd"] / Flux.settings["note"]["ar"]

func _on_save_settings_pressed():
	var f = FileAccess.open("user://settings.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(Flux.settings))

func _on_enable_ruwo_checkbox_toggled(button_pressed):
	Flux.settings["ui"]["enable_ruwo"] = button_pressed

func _on_ar_value_changed(value):
	Flux.settings["note"]["ar"] = value
	update_at()

func _on_sd_value_changed(value):
	Flux.settings["note"]["sd"] = value
	update_at()

func _on_music_volume_value_changed(value):
	Flux.settings["audio"]["music_volume"] = value / 100.0

func _on_speed_value_changed(value):
	Flux.mods.speed = value

func _on_seek_value_changed(value):
	Flux.mods.seek = value

func _on_cursor_sensitivity_value_changed(value):
	Flux.settings.cursor.sensitivity = value
