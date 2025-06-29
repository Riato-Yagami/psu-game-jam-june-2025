extends Node

var capture: AudioEffectCapture
var mic_bus_index: int
var mic_player: AudioStreamPlayer

func _ready():
	# 1. Prépare le bus d'enregistrement
	mic_bus_index = AudioServer.get_bus_index("Record")

	# 2. Récupère l'effet AudioEffectCapture
	var effect = AudioServer.get_bus_effect(mic_bus_index, 0)
	if effect is AudioEffectCapture:
		capture = effect
	else:
		push_error("AudioEffectCapture non trouvé sur le bus 'Record'.")
		return

	# 3. Crée un AudioStreamPlayer avec AudioStreamMicrophone
	mic_player = AudioStreamPlayer.new()
	mic_player.stream = AudioStreamMicrophone.new()
	mic_player.bus = "Record"
	add_child(mic_player)
	mic_player.play()

	print("Micro activé et prêt.")

func _process(_delta):
	if capture and capture.can_get_buffer(512):
		var samples = capture.get_buffer(512)
		if samples.is_empty():
			print("Aucun échantillon capturé.")
			return

		var amplitude = _calculate_amplitude(samples)
		setMicroValue(amplitude)


func setMicroValue(amplitude):
	if amplitude <= 0:
		return
	amplitude = amplitude * 4
	var laserContainer = get_node("../Game/LaserContainer")
	var laser = laserContainer.laser
	laser.setAngle(amplitude * PI)
	print(amplitude * PI)
	

func _calculate_amplitude(samples: PackedVector2Array) -> float:
	var sum = 0.0
	for s in samples:
		sum += abs(s.x)  # Mono / canal gauche
	return sum / samples.size()
