# https://godotshaders.com/shader/spectrum-analyzer/
extends Node
class_name SpectrumAnalyzer

# Tenor : 174 -> 523
const VU_COUNT = 30
const FREQ_MAX = 700 #11050.0
const FREQ_MIN = 0
const MIN_DB = 60
const ANIMATION_SPEED = 0.1
const HEIGHT_SCALE = 8.0

#@export var color_rect : MeshInstance3D
@export var shader : ShaderMaterial

var min_values = []
var max_values = []

func _ready():
	#spectrum = AudioServer.get_bus_effect_instance(0, 0)
	min_values.resize(VU_COUNT)
	min_values.fill(0.0)
	max_values.resize(VU_COUNT)
	max_values.fill(0.0)
	
func analyze(
	spectrum : AudioEffectSpectrumAnalyzerInstance,
	freq_min : float = FREQ_MIN,
	freq_max : float = FREQ_MAX,
	freq_count : int = VU_COUNT
	):
	var prev_hz = 0
	var data : Array = []
	
	for i in range(1, freq_count + 1):
		var hz = i * (freq_max - freq_min) / freq_count
		var f = spectrum.get_magnitude_for_frequency_range(prev_hz, hz)
		var energy = clamp((MIN_DB + linear_to_db(f.length())) / MIN_DB, 0.0, 1.0)
		data.append(energy * HEIGHT_SCALE)
		prev_hz = hz
	
	visualizer(data)
	return data
	
func visualizer(data : Array):
	for i in range(VU_COUNT):
		if data[i] > max_values[i]:
			max_values[i] = data[i]
		else:
			max_values[i] = lerp(max_values[i], data[i], ANIMATION_SPEED)
		if data[i] <= 0.0:
			min_values[i] = lerp(min_values[i], 0.0, ANIMATION_SPEED)
	var fft = []
	for i in range(VU_COUNT):
		fft.append(lerp(min_values[i], max_values[i], ANIMATION_SPEED))
	#print(color_rect.get_surface_override_material_count())
	#print(fft)
	shader.set_shader_parameter("freq_data", fft.slice(4,fft.size()-1))
	#color_rect.surface_get_material().set_shader_parameter("freq_data", fft)
	#get_material()
#func _process(delta):
