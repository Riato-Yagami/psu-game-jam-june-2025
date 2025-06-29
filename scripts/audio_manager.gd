extends Node

var capture : AudioEffectCapture
var mic_bus_index : int

func _ready():
	# Récupère l'index du bus "Record"
	mic_bus_index = AudioServer.get_bus_index("Record")
	

	# Vérifie que le bus contient un AudioEffectCapture
	var effect = AudioServer.get_bus_effect(mic_bus_index, 0)
	if effect is AudioEffectCapture:
		capture = effect
	else:
		push_error("Aucun AudioEffectCapture trouvé sur le bus 'Record'.")

func _process(delta):
	if capture and capture.can_get_buffer(512):
		var samples := capture.get_buffer(512)
		var amplitude := _calculate_amplitude(samples)
		print("Amplitude du micro: ", amplitude)

func _calculate_amplitude(samples: PackedVector2Array) -> float:
	if samples.is_empty():
		return 0.0

	var sum = 0.0
	for s in samples:
		sum += abs(s.x)  # .x = canal gauche ; .y = canal droit (si stéréo)
	return sum / samples.size()
