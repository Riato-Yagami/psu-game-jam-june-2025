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

# Jules conf
#var min_f = 180
#var max_f = 550

var min_f = 250
var max_f = 400

func _process(_delta):
	var frequencies = spectrum_analyzer.analyze(spectrum,min_freq,max_freq,freq_count)
	var amplitude = average(frequencies)
	shader_material.set_shader_parameter("sin_amp", amplitude * 0.05)

	if(amplitude > 0):
		var freq = FrequencyParser.dominant_freq(frequencies,min_freq,max_freq,freq_count)
		min_f = min(freq + 50,min_f)
		max_f = max(freq - 50,max_f)
		#print(min_f," ",max_f) # 108.333333333333 628.333333333333
		shader_material.set_shader_parameter("sin_freq", freq / 20.0)
		var adjusted_freq = adjust(freq,min_f,max_f)
		laserContainer.set_laser_position(_delta, adjusted_freq)
		#var midi = FrequencyParser.midi(freq)
		#var adjusted_midi = adjust(freq,min_midi,max_midi)
		#laserContainer.set_laser_position(_delta, adjusted_midi)

func adjust(val, min, max):
	var adjusted = float(val - min) / max(max - min,1)
	adjusted = clamp(adjusted,0,1)
	return adjusted
