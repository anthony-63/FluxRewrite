extends Node
class_name TimeManager
signal finished

@export var playing:bool = false
@export var playback_speed:float = 1

var last_time:int = 0
@export var real_time:float = 0
var current_time:float:
	get: return real_time
@export var length:float = 0

func start(from:float=0):
	last_time = Time.get_ticks_usec()
	real_time = min(from * playback_speed, from)
	playing = true
func seek(from:float=0):
	last_time = Time.get_ticks_usec()
	real_time = from * playback_speed
func finish():
	playing = false
	finished.emit()

var paused:bool = false
func _notification(what):
	if what == Node.NOTIFICATION_PAUSED:
		paused = true
		just_paused()
	elif what == Node.NOTIFICATION_UNPAUSED:
		paused = false
		just_unpaused()
func just_paused():
	pass
func just_unpaused():
	last_time = Time.get_ticks_usec()

func _process(delta):
	if !playing: return
	var now = Time.get_ticks_usec()
	var time = playback_speed * (now - last_time) / 1000000.0
	last_time = now
	real_time += time
	try_finish()

func try_finish():
	if current_time > length:
		finish()
