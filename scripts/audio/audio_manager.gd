extends Node
class_name AudioManager

var capture: AudioEffectCapture
var mic_bus_index: int
var mic_player: AudioStreamPlayer
var laser : Laser
var laserContainer : LaserContainer
var spectrum : AudioEffectSpectrumAnalyzerInstance
var samples : PackedVector2Array
var max_amplitude = 4

@export var spectrum_analyzer : SpectrumAnalyzer
@export var shader_material : ShaderMaterial

func _ready():
	# 0. Get laser
	laserContainer = SceneManager.game.get_node("LaserContainer")
	laser = laserContainer.laser

	# 1. Prépare le bus d'enregistrement
	mic_bus_index = AudioServer.get_bus_index("Record")

	# 2. Récupère l'effet AudioEffectCapture
	spectrum = AudioServer.get_bus_effect_instance(mic_bus_index, 0)
	
	# 3. Crée un AudioStreamPlayer avec AudioStreamMicrophone
	mic_player = AudioStreamPlayer.new()
	mic_player.stream = AudioStreamMicrophone.new()
	mic_player.bus = "Record"
	add_child(mic_player)
	mic_player.play()

	print("Micro activé et prêt.")

func average(array : Array) -> float:
	var sum : float = 0
	for val in array:
		sum+= val
	return sum / array.size()

# Debug_var
var min_midi = 50.0
var max_midi = 65.0

var min_freq = 50
var max_freq = 700
var freq_count = 30

func _process(_delta):
	var frequencies = spectrum_analyzer.analyze(spectrum,min_freq,max_freq,freq_count)
	var amplitude = average(frequencies)
	#var note = Parse.notes(frequencies,50,700,30)
	var freq = FrequencyParser.dominant_freq(frequencies,min_freq,max_freq,freq_count)
	#var pitch = FrequencyParser.pitch_hps(frequencies,min_freq,max_freq,freq_count)
	
	if(freq > 0):
		shader_material.set_shader_parameter("sin_freq", freq / 20.0)
		shader_material.set_shader_parameter("sin_amp", amplitude * 0.05)
		var midi = FrequencyParser.midi(freq)
		#print(midi)
		var adjusted_midi = float(midi - min_midi) / max(max_midi - min_midi,1)
		adjusted_midi = clamp(adjusted_midi,0,1)
		#print(midi)
		laserContainer.set_laser_position(_delta, adjusted_midi)
		#print(freq)
		#laserContainer.set_laser_position(_delta, freq / (max_freq - min_freq))
	else :
		shader_material.set_shader_parameter("sin_amp", 0)
	#if(note > 0):
		#print(note)
#
		##min_note = min(note,min_note)
		##max_note = max(note,max_note)
		##print(min_note," ",max_note)
		
		#print(adjusted_note)
		##laser.setAngle(adjusted_note * 2 * PI)
		#laserContainer.set_laser_position(_delta, adjusted_note)
	##laser.setAngle(amplitude / max_amplitude * 2 * PI)
