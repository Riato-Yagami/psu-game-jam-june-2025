extends Node

var mic_capture: AudioEffectCapture
var buffer = []

const SAMPLE_MIN_CEIL = 0.0
const TRIGGER_COULDOWN = 0.1
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
	
	
	
	if note < 0:
		return
		
		
	var pos = getTargetPosition(note)
	print("Note: ", note, " pos=[", pos.x, ",", pos.y, "]")
	
	# TODO: call external function (and give pos)
	



# Returns -1 in case of invalid note, else an float beetween 0 and 7
func convertFrequencyToNote(freq):
	if freq <= 0.0 || freq >= 1000:
		return -1

	# distance en demi-tons depuis A4, ramenée pour que C=0
	var n = 12.0 * log(freq / 440.0) / log(2.0)
	var semitone = fmod(n + 9.0, 12.0)

	# mapping des 12 demi-tons vers les 7 notes naturelles
	const NATURAL_NOTES = [
		0.0,  # Do
		0.5,  # Do#
		1.0,  # Re
		1.5,  # Re#
		2.0,  # Mi
		3.0,  # Fa
		3.5,  # Fa#
		4.0,  # Sol
		4.5,  # Sol#
		5.0,  # La
		5.5,  # La#
		6.0   # Si
	]

	var i = int(floor(semitone)) % 12
	var f = semitone - i
	var i_next = (i + 1) % 12

	var val = (1.0 - f) * NATURAL_NOTES[i] + f * NATURAL_NOTES[i_next]
	return fmod(val, 7.0)

	
	
	

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
		
		if pitch < 0 or pitch > 1300:
			return 0
		
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


func getTargetPosition(note):
	var intNote = int(note)
	var current = TargetPointList.LIST[intNote]
	var next = TargetPointList.LIST[0 if intNote==6 else 0]
	
	var decalage = note - intNote
	
	return TargetPoint.interpolate(current, next, decalage)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
