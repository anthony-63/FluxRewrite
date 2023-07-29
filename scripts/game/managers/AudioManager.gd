extends TimeManager

@onready var audio_player:AudioStreamPlayer

var audio_stream:AudioStream:
	get:
		return audio_stream
	set(value):
		length = value.get_length()
		audio_stream = value
var time_delay:float = 0

func _ready():
	audio_player = AudioStreamPlayer.new()

func _set_offset():
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	audio_player.seek(real_time+time_delay)
func _start_audio():
	if audio_stream is AudioStreamMP3:
		(audio_stream as AudioStreamMP3).loop = false
	if audio_stream is AudioStreamWAV:
		(audio_stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_DISABLED
	if audio_stream is AudioStreamOggVorbis:
		(audio_stream as AudioStreamOggVorbis).loop = false
	audio_player.stream = audio_stream
	audio_player.play(real_time)
	_set_offset()

func play(music_stream: AudioStreamPlayer):
	music_stream.stream = Flux.current_map.audio_stream
	music_stream.play(0.0)
	self.start()

func _process(delta:float):
	if !playing: return
	super._process(delta)

	if real_time >= 0 and !playing and playback_speed > 0:
		_start_audio()
	if (real_time < 0 or playback_speed <= 0) and audio_player.playing:
		audio_player.stop()
	if playback_speed > 0:
		audio_player.pitch_scale = playback_speed

func seek(from:float=0):
	super.seek(from)
	_set_offset()

func just_unpaused():
	super.just_unpaused()
	print("hi")
	var pbp = audio_player.get_playback_position()

func just_paused():
	audio_player.stop()
