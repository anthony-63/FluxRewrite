extends Node

func _ready():
	$Changeables/Settings/SettingTypes/Note/AR.value = Flux.settings["note"]["ar"]
	$Changeables/Settings/SettingTypes/Note/SD.value = Flux.settings["note"]["sd"]
	

func _process(delta):
	if Flux.settings["ui"]["enable_ruwo"]:
		$Ruwo.show()
	else:
		$Ruwo.hide()

func _on_enable_ruwo_checkbox_toggled(button_pressed):
	Flux.settings["ui"]["enable_ruwo"] = button_pressed

func update_at():
	Flux.settings["note"]["approach_time"] = Flux.settings["note"]["sd"] / Flux.settings["note"]["ar"]

func _on_ar_value_changed(value):
	Flux.settings["note"]["ar"] = value
	update_at()
	
func _on_sd_value_changed(value):
	Flux.settings["note"]["sd"] = value
	update_at()

func _on_save_settings_pressed():
	var f = FileAccess.open("user://settings.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(Flux.settings))
