extends Node3D

const record_fps = 60
const ms_per_frame = 1000/record_fps
var record_timer = 0.0
var sync = 0.0

func update_mods():
	if Flux.mods.speed != 1.0:
		$HUD/Mods.show()
		$HUD/Mods/ModsString.text += "S" + str(round(Flux.mods.speed * 100.0)) + "\n"
	
func update_debug_info():
	$DbgInfoParent/DbgInfo.text = ""
	$DbgInfoParent/DbgInfo.text += "CameraRotation x y z" + str($Camera3D.rotation_degrees.x) + ", " + str($Camera3D.rotation_degrees.y) + ", " + str($Camera3D.rotation_degrees.z) + "\n"
	$DbgInfoParent/DbgInfo.text += "Cursor x y: " + str($Cursor.transform.origin.x) + ", " + str($Cursor.transform.origin.y) + "\n"
	$DbgInfoParent/DbgInfo.text += "InvisCursor x y: " + str($InvisCursor.transform.origin.x) + "," + str($InvisCursor.transform.origin.y) + "\n"
	$DbgInfoParent/DbgInfo.text += "Replay Timer: " + str(record_timer) + "\n"
	$DbgInfoParent/DbgInfo.text += "Replay Sync Interval: " + str(sync) + "\n"
	
func _ready():
	Flux.game_stats.hp = Flux.game_stats.max_hp
	
	reset_game()
	$AudioManager.connect("finished", game_finished)
	$Transition.show()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	update_mods()
	
	$HUD/ReplayLabel.visible = Flux.replaying
	
	if not Flux.current_map.meta.artist == "":
		$HUD/MapName.text = Flux.current_map.meta.artist + " - " + Flux.current_map.meta.title
	else:
		$HUD/MapName.text = Flux.current_map.meta.title
	
	if not Flux.replaying: ReplayManager.start_replay_save()
	await get_tree().create_timer(Flux.get_setting("game", "wait_time")).timeout
	
	$AudioManager.length = Flux.current_map.diffs.default[-1].ms
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(Flux.get_setting("audio", "music_volume")))

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

func _process(delta):
	record_timer += delta
	
	if Flux.replaying and (record_timer * 1000.0) >= ms_per_frame:
		var t = Flux.replay_file.get_float()
		var cx = Flux.replay_file.get_float()
		var cy = Flux.replay_file.get_float()
		$Cursor.transform.origin.x = cx
		$Cursor.transform.origin.y = cy
		sync = (t - $AudioManager.current_time) / 1000.0
		record_timer = -sync
		
	if Flux.get_setting("game", "replay") and not Flux.replaying and $AudioManager.current_time != null and (record_timer * 1000.0) >= ms_per_frame:
		ReplayManager.save_stamp($AudioManager.current_time, Vector2($Cursor.transform.origin.x, $Cursor.transform.origin.y))
		record_timer = 0.0
	
	$HUD/TimeIntoMap.text = Flux.ms_to_min_sec_str($AudioManager.current_time) + "/" + Flux.ms_to_min_sec_str(Flux.current_map.diffs["default"][-1]["ms"])
	$HUD/Misses/MissAmount.text = str(Flux.game_stats.misses)
	$HUD/Hits/HitAmount.text = str(Flux.game_stats.hits)
	$HUD/Combo.text = str(Flux.game_stats.combo) + "x"
	$HUD/Total/TotalAmount.text = str(Flux.game_stats.hits + Flux.game_stats.misses)
	
	$HUD/HealthBarViewport/HealthBarProgress.max_value = Flux.game_stats.max_hp
	$HUD/HealthBarViewport/HealthBarProgress.value = Flux.game_stats.hp
	
	if Flux.get_setting("game", "spin"):
		pass
	else:
		$Camera3D.global_transform.origin.x = $Cursor.global_transform.origin.x * Flux.get_setting("game", "parallax")
		$Camera3D.global_transform.origin.y = $Cursor.global_transform.origin.y * Flux.get_setting("game", "parallax")
	
	if Flux.game_stats.hp == 0.0:
		set_all_finished_info()
		$HUD/FailedText.show()
		await get_tree().create_timer(0.5).timeout
		if not Flux.replaying: ReplayManager.end_replay()
		$Transition.transition_out()
		await get_tree().create_timer(Flux.transition_time).timeout
		$HUD/FailedText.hide()
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")
	
	if Input.is_action_just_pressed("leave_map"):
		set_all_finished_info()
		if not Flux.replaying: ReplayManager.end_replay()
		$Transition.transition_out()
		await get_tree().create_timer(Flux.transition_time).timeout
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")
		
	update_debug_info()
