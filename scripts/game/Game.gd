extends Node3D


func update_mods():
	if Flux.mods.speed != 1.0:
		$HUD/Mods.show()
		$HUD/Mods/ModsString.text += "S" + str(round(Flux.mods.speed * 100.0)) + "\n"
	
func _ready():
	Flux.game_stats.hp = Flux.game_stats.max_hp
	var draw = Draw3D.new()
	draw.name = "Draw3D"
	add_child(draw)
	
	reset_game()
	$AudioManager.connect("finished", game_finished)
	$Transition.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	update_mods()
	
	if not Flux.current_map.meta.artist == "":
		$HUD/MapName.text = Flux.current_map.meta.artist + " - " + Flux.current_map.meta.title
	else:
		$HUD/MapName.text = Flux.current_map.meta.title
		
	$AudioManager.length = Flux.current_map.diffs.default[-1].ms
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Flux.settings.audio.music_volume))
	await get_tree().create_timer(Flux.default_settings.game.wait_time).timeout
	
#	Flux.audio_manager.seek(-Flux.default_settings.game.wait_time)
	$AudioManager.play($MusicStream)
	$AudioManager.playback_speed = Flux.mods.speed
#	Flux.audio_manager.seek(Flux.mods.seek)
	AudioServer.playback_speed_scale = Flux.mods.speed
	
func reset_game():
		Flux.game_stats.misses = 0
		Flux.game_stats.hits = 0
		Flux.game_stats.max_combo = 0
		Flux.game_stats.combo = 0
		Flux.game_stats.hp = Flux.game_stats.max_hp
		
		$NoteSpawner.note_index = 0
		for child in $NoteSpawner.get_children():
			child.queue_free()

func set_all_finished_info():
	Flux.map_finished_info.misses = Flux.game_stats.misses
	Flux.map_finished_info.max_combo = Flux.game_stats.max_combo
	Flux.map_finished_info.accuracy = (float(Flux.game_stats.hits) / float(Flux.game_stats.hits + Flux.game_stats.misses)) * 100.0
	Flux.map_finished_info.played = true
	Flux.update_selected_map = true
	
func game_finished():
	Flux.map_finished_info.passed = true
	set_all_finished_info()
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

func _process(_delta):
	$HUD/TimeIntoMap.text = Flux.ms_to_min_sec_str($AudioManager.current_time) + "/" + Flux.ms_to_min_sec_str(Flux.current_map.diffs["default"][-1]["ms"])
	$HUD/Misses/MissAmount.text = str(Flux.game_stats.misses)
	$HUD/Hits/HitAmount.text = str(Flux.game_stats.hits)
	$HUD/Combo.text = str(Flux.game_stats.combo) + "x"
	$HUD/Total/TotalAmount.text = str(Flux.game_stats.hits + Flux.game_stats.misses)
	
	$HUD/HealthBarViewport/HealthBarProgress.max_value = Flux.game_stats.max_hp
	$HUD/HealthBarViewport/HealthBarProgress.value = Flux.game_stats.hp
	if Flux.settings.game.spin:
		$Camera3D.look_at($InvisCursor.transform.origin, Vector3.UP)
	else:
		$Camera3D.global_transform.origin.x = $Cursor.global_transform.origin.x * Flux.get_setting("game", "parallax")
		$Camera3D.global_transform.origin.y = $Cursor.global_transform.origin.y * Flux.get_setting("game", "parallax")
	
	$Draw3D.clear()
	
	if Flux.game_stats.hp == 0.0:
		set_all_finished_info()
		$HUD/FailedText.show()
		await get_tree().create_timer(1.5).timeout
		$HUD/FailedText.hide()
		
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")
	
	if Input.is_action_just_pressed("leave_map"):
		set_all_finished_info()
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")
		
