extends Node
class_name AudioManager

var capture: AudioEffectCapture
var mic_bus_index: int
var mic_player: AudioStreamPlayer
var laser : Laser
var spectrum : AudioEffectSpectrumAnalyzerInstance
var samples : PackedVector2Array
var max_amplitude = 4
@export var spectrum_analyzer : SpectrumAnalyzer

func _ready():
	# 0. Get laser
	var laserContainer : LaserContainer = SceneManager.game.get_node("LaserContainer")
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
var min_note = 1000
var max_note = 0
func _process(_delta):
	var frequencies = spectrum_analyzer.analyze(spectrum,700,30)
	var amplitude = average(frequencies)
	var note = Parse.notes(frequencies,700,30)
	#print(note)

	if(note > 0):
		min_note = min(note,min_note)
		max_note = max(note,max_note)
		#print(min_note," ",max_note)
		var adjusted_note = (note - 46.0) / (76.0 - 46.0)
		print(adjusted_note)
		laser.setAngle(adjusted_note * 2 * PI)
	#laser.setAngle(amplitude / max_amplitude * 2 * PI)
