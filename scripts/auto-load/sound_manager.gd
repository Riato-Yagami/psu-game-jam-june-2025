extends Node

var sound_r = preload("res://scenes/sound.tscn")
var sounds_node
var music_node
var sound_path = "res://audio/sounds/"
var default_music_volume
var is_Mute = false

var music_bus

var loops : Dictionary = {}
#var music_pitch_effect

var music

func _ready():
	#music_bus = AudioServer.get_bus_index("Music")
	#music_pitch_effect = AudioServer.get_bus_effect(music_bus, 0)
	
	var audio_node = SceneManager.main.get_node("Audio")
	sounds_node = audio_node.get_node("Sounds")
	music_node  = audio_node.get_node("Music")
	default_music_volume = music_node.volume_db
	start_game_music()
	
func play(clip_name,db = 1, count = 1, time = 0):
	var s : Sound = sound_r.instantiate()
	if(!sounds_node): return
	sounds_node.add_child(s)
	
	var clip = sound_path + clip_name + ".wav"
	
	if(count > 1):
		var clips = []
		for i in range(count):
			clips.append(clip_name + str(i+1))
		clip = sound_path + clips.pick_random() + ".wav"
		
	s.play_clip(clip, time)
	s.volume_db = db
	
	return s
	
func _add_loop(clip_name : String):
	var s : Sound = sound_r.instantiate()
	sounds_node.add_child(s)
	
	var clip = sound_path + clip_name + ".wav"
	
	s.play_clip(clip)
	
	loops[clip_name] = s

func _check_loop(clip_name : String) -> void:
	if not loops.has(clip_name) : _add_loop(clip_name)
	
func mute_loop(clip_name : String):
	_check_loop(clip_name)
	loops[clip_name].volume_db = -80

func start_loop(clip_name : String, db = null):
	_check_loop(clip_name)
	if(loops[clip_name].playing): return
	if(db != null): loops[clip_name].volume_db = db
	loops[clip_name].play()
	
func stop_loop(clip_name : String):
	_check_loop(clip_name)
	loops[clip_name].stop()
	
func mute_music():
	is_Mute = !is_Mute
	music_node.volume_db = -80 if is_Mute else default_music_volume
#	muteButton.texture = muteSprite if isMute else unMuteSprite

func start_game_music():
	#music_node.stream = music
	#set_music_speed(1)
	music_node.play()

func mute():
	var volume = 0 if is_mute() else -80
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),volume)

func is_mute():
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) == -80
#func set_music_speed(speed):
	#music_node.pitch_scale = speed
	#music_pitch_effect.pitch_scale = 1/speed
