
extends Node

var mic_capture: AudioEffectCapture
var buffer = []

const SAMPLE_MIN_CEIL = 3.0
const TRIGGER_COULDOWN = 1.0
var triggerCouldown = TRIGGER_COULDOWN

func _ready():
	# Crée le flux micro
	var mic_stream = AudioStreamMicrophone.new()
	
	# Configure un AudioStreamPlayer si tu en as un
	var mic_player = AudioStreamPlayer.new()
	mic_player.name = "MicPlayer"
	mic_player.stream = mic_stream
	mic_player.bus = "Record"
	add_child(mic_player)
	
	# Joue le micro
	mic_player.play()
	
	# Récupère l'effet de capture sur le bus "Record"
	mic_capture = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 0)
	
	
func _process(_delta):
	triggerCouldown -= _delta
	if (triggerCouldown > 0):
		return
		
	triggerCouldown += TRIGGER_COULDOWN
	var frequency = getFrequency()
	
	# TODO: call external function
	
	
func getFrequency():
	if mic_capture and mic_capture.get_frames_available() >= 1024:
		var audio_data = mic_capture.get_buffer(1024)  # PackedVector2Array
		var samples := PackedFloat32Array()
		for v in audio_data:
			samples.append(v.x)  # Utilise .y pour le canal droit

		var pitch = detect_pitch(samples)
		if pitch > 0:
			print("Fréquence chantée : ", pitch, " Hz")


func detect_pitch(samples: PackedFloat32Array) -> float:
	# Algorithme de détection très simple (AutoCorrelation)
	var sample_rate = 44100
	var max_lag = 1024
	var best_offset = 0
	var best_correlation = SAMPLE_MIN_CEIL
	var best_sum = 0.0

	for lag in range(20, max_lag): # ignore les très basses fréquences
		var sum = 0.0
		for i in range(samples.size() - lag):
			sum += samples[i] * samples[i + lag]
		
		if sum > best_correlation:
			best_correlation = sum
			best_offset = lag
			best_sum = sum

	if best_offset == 0:
		return -1.0

	return sample_rate / best_offset
