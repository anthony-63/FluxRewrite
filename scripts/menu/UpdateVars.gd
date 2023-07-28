extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Changeables/Settings/SettingTypes/Note/NoteVbox/ARHbox/AR.value = Flux.get_setting("note", "ar")
	$Changeables/Settings/SettingTypes/Note/NoteVbox/SDHbox/SD.value = Flux.get_setting("note", "sd")
	$Changeables/Settings/SettingTypes/Note/NoteVbox/FadeHbox/EnableFade.button_pressed = Flux.get_setting("note", "fade")
	$Changeables/Settings/SettingTypes/UI/UIVbox/EnableRuwoCheckbox.button_pressed = Flux.get_setting("ui", "enable_ruwo")
	$Changeables/Settings/SettingTypes/Sound/SoundVbox/MusicVolHbox/MusicVolume.value = Flux.get_setting("audio", "music_volume") * 100.0
	$Changeables/Settings/SettingTypes/Cursor/CursorVbox/CursorScaleHbox/CursorScale.value = Flux.get_setting("cursor", "scale")
	$Changeables/Settings/SettingTypes/Cursor/CursorVbox/CursorSensHbox/CursorSensitivity.value = Flux.get_setting("cursor", "sensitivity")
	$Changeables/Settings/SettingTypes/Cursor/CursorVbox/ParallaxHbox/Parallax.value = Flux.get_setting("game", "parallax")
	$Changeables/Settings/SettingTypes/Cursor/CursorVbox/SpinHbox/EnableSpin.button_pressed = Flux.get_setting("game", "spin")
	$Changeables/Mods/ModsVbox/SpeedHbox/Speed.value = Flux.mods.speed
	$MapInfoPanel/Version.text = Flux.version_string
	
	var current_id: int = 0
	for noteset in Flux.notesets.keys():
		$Changeables/Settings/SettingTypes/Sets/SetsVbox/NotesetHbox/Noteset.add_item(noteset)
		if Flux.get_setting("sets", "noteset") == noteset:
			$Changeables/Settings/SettingTypes/Sets/SetsVbox/NotesetHbox/Noteset.selected = current_id
		current_id = current_id + 1

func _process(_delta):
	Flux.settings.sets.noteset = $Changeables/Settings/SettingTypes/Sets/SetsVbox/NotesetHbox/Noteset.get_item_text($Changeables/Settings/SettingTypes/Sets/SetsVbox/NotesetHbox/Noteset.selected)
	if Flux.get_setting("ui", "enable_ruwo"):
		$MapList/Ruwo.show()
	else:
		$MapList/Ruwo.hide()

func save_settings():
	var f: FileAccess = FileAccess.open("user://settings.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(Flux.settings))

func update_at():
	Flux.settings.note.approach_time = Flux.get_setting("note", "sd") / Flux.get_setting("note", "ar")
	save_settings()

func _on_enable_ruwo_checkbox_toggled(button_pressed):
	Flux.settings.ui.enable_ruwo = button_pressed
	save_settings()

func _on_ar_value_changed(value):
	Flux.settings.note.ar = value
	update_at()
	save_settings()

func _on_sd_value_changed(value):
	Flux.settings.note.sd = value
	update_at()
	save_settings()

func _on_music_volume_value_changed(value):
	Flux.settings.audio.music_volume = value / 100.0
	save_settings()

func _on_speed_value_changed(value):
	Flux.mods.speed = value
	save_settings()
	
func _on_cursor_sensitivity_value_changed(value):
	Flux.settings.cursor.sensitivity = value
	save_settings()

func _on_cursor_scale_value_changed(value):
	Flux.settings.cursor.scale = value
	save_settings()

func _on_enable_fade_toggled(button_pressed):
	Flux.settings.note.fade = button_pressed
	save_settings()

func _on_enable_spin_toggled(button_pressed):
	Flux.settings.game.spin = button_pressed
	save_settings()

func _on_parallax_value_changed(value):
	Flux.settings.game.parallax = value
	save_settings()

func _on_noteset_item_selected(index):
	Flux.settings.sets.noteset = $Changeables/Settings/SettingTypes/Sets/SetsVbox/NotesetHbox/Noteset.get_item_text(index)
	save_settings()

func _on_enable_drift_toggled(button_pressed):
	Flux.settings.cursor.drift = button_pressed
	save_settings()
