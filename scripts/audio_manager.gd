
extends Node

var mic_capture: AudioEffectCapture
var buffer = []

const SAMPLE_MIN_CEIL = 1.0
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
		emptyBuffer()
		return
		
	triggerCouldown += TRIGGER_COULDOWN
	var note = convertFrequencyToNote(getFrequency())
	
	
	# TODO: call external function
	print("Note: ", note)
	
	

const FREQUENCIES = [
	261.63, # Do
	293.66, # Re
	329.63, # Mi
	349.23, # Fa
	392.00, # Sol
	440.00, # La
	493.88, # Si
	523.25 # Do
]

# Returns -1 in case of invalid note, else an integer in [0;7]
func convertFrequencyToNote(frequency):
	print("frq", frequency)
	if frequency < FREQUENCIES[0]:
		return -1
	
	for i in range(1, FREQUENCIES.size()):
		print(i, ": ", frequency, " > ", FREQUENCIES[i])
		if frequency < FREQUENCIES[i]:
			return i-1
	
	return -1
	

func emptyBuffer():
	if mic_capture and mic_capture.get_frames_available() >= 512:
		mic_capture.get_buffer(512)


func getFrequency():
	if mic_capture and mic_capture.get_frames_available() >= 1024:
		var audio_data = mic_capture.get_buffer(1024)  # PackedVector2Array
		var samples := PackedFloat32Array()
		for v in audio_data:
			samples.append(v.x)  # Utilise .y pour le canal droit

		var pitch = detect_pitch(samples)
		print("Fréquence chantée : ", pitch, " Hz")
		return pitch

	return 0

func detect_pitch(samples: PackedFloat32Array) -> float:
	# Algorithme de détection très simple (AutoCorrelation)
	var sample_rate = 44100
	var max_lag = 1024
	var best_offset = 0
	var best_correlation = SAMPLE_MIN_CEIL

	for lag in range(20, max_lag): # ignore les très basses fréquences
		var sum = 0.0
		for i in range(samples.size() - lag):
			sum += samples[i] * samples[i + lag]
		
		if sum > best_correlation:
			best_correlation = sum
			best_offset = lag

	if best_offset == 0:
		return -1.0

	return sample_rate / best_offset
