extends Node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Flux.replaying:
		Flux.settings = Flux.tmp_settings.duplicate(true)
		Flux.mods = Flux.tmp_mods.duplicate(true)
		Flux.replaying = false
	$Changeables/Settings/SettingTypes/Note/NoteVbox/ARHbox/AR.value = Flux.get_setting("note", "ar")
	$Changeables/Settings/SettingTypes/Note/NoteVbox/SDHbox/SD.value = Flux.get_setting("note", "sd")
	$Changeables/Settings/SettingTypes/Note/NoteVbox/FDHbox/FD.value = Flux.get_setting("note", "fd")
	$Changeables/Settings/SettingTypes/Note/NoteVbox/FadeHbox/EnableFade.button_pressed = Flux.get_setting("note", "fade")
	$Changeables/Settings/SettingTypes/UI/UIVbox/RuwoHbox/EnableRuwoCheckbox.button_pressed = Flux.get_setting("ui", "enable_ruwo")
	$Changeables/Settings/SettingTypes/Sound/SoundVbox/MusicVolHbox/MusicVolume.value = Flux.get_setting("audio", "music_volume") * 100.0
	$Changeables/Settings/SettingTypes/Cursor/CursorVbox/CursorScaleHbox/CursorScale.value = Flux.get_setting("cursor", "scale")
	$Changeables/Settings/SettingTypes/Cursor/CursorVbox/CursorSensHbox/CursorSensitivity.value = Flux.get_setting("cursor", "sensitivity")
	$Changeables/Settings/SettingTypes/UI/UIVbox/ParallaxHbox/Parallax.value = Flux.get_setting("game", "parallax")
	$Changeables/Settings/SettingTypes/Cursor/CursorVbox/SpinHbox/EnableSpin.button_pressed = Flux.get_setting("game", "spin")
	$Changeables/Settings/SettingTypes/Cursor/CursorVbox/DriftHbox/EnableDrift.button_pressed = Flux.get_setting("cursor", "drift")
	$Changeables/Settings/SettingTypes/UI/UIVbox/DebugHbox/EnableDebug.button_pressed = Flux.get_setting("ui", "debug")
	$Changeables/Mods/ModsVbox/SpeedHbox/Speed.value = Flux.mods.speed
	$Changeables/Mods/ModsVbox/NoFailHbox/NoFail.button_pressed = Flux.mods.no_fail
	$Changeables/Mods/ModsVbox/VisualMapHbox/VisualMap.button_pressed = Flux.mods.visual_map
	$Changeables/Mods/ModsVbox/Seek/Seek.value = Flux.mods.seek
	$MapInfoPanel/Version.text = Flux.version_string
	
	var current_id: int = 0
	for noteset in Flux.notesets.keys():
		$Changeables/Settings/SettingTypes/Sets/SetsVbox/NotesetHbox/Noteset.add_item(noteset)
		if Flux.get_setting("sets", "noteset") == noteset:
			$Changeables/Settings/SettingTypes/Sets/SetsVbox/NotesetHbox/Noteset.selected = current_id
		current_id += 1
	current_id = 0
	for cursorset in Flux.cursorsets.keys():
		$Changeables/Settings/SettingTypes/Sets/SetsVbox/CursorsetHbox/Cursorset.add_item(cursorset)
		if Flux.get_setting("sets", "cursorset") == cursorset:
			$Changeables/Settings/SettingTypes/Sets/SetsVbox/CursorsetHbox/Cursorset.selected = current_id
		current_id +=  1
		

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

func _on_no_fail_checkbox_toggled(button_pressed):
	Flux.mods.no_fail = button_pressed

func _on_visual_map_toggled(button_pressed):
	Flux.mods.visual_map = button_pressed

func _on_cursorset_item_selected(index):
	Flux.settings.sets.cursorset = $Changeables/Settings/SettingTypes/Sets/SetsVbox/CursorsetHbox/Cursorset.get_item_text(index)
	save_settings()

func _on_enable_debug_toggled(button_pressed):
	Flux.settings.ui.debug = button_pressed
	save_settings()

func _on_seek_value_changed(value):
	Flux.mods.seek = value

func _on_fd_value_changed(value):
	Flux.settings.note.fade_distance = value / 100.0
