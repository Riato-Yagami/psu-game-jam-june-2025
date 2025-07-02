extends Object
class_name FrequencyParser

static func midi(frequency) -> int :
	var midi : int = round(69 + 12 * log(frequency / 440.0) / log(2))
	return midi
	
static func note(midi) -> Array :
	var note_names : Array[String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	var note : String = note_names[midi % 12]
	var octave : int = int(midi / 12) - 1
	return [note,octave]

static func average_freq(
	frequencies,
	freq_min: float,
	freq_max: float,
	freq_count: int) -> float:
		
	var sum_amp := 0.0
	var weighted_sum := 0.0
	
	for i in range(freq_count):
		var amp : float = frequencies[i]
		var freq : float = float(i) / freq_count * (freq_max - freq_min) + freq_min
		sum_amp += amp
		weighted_sum += amp * freq
	
	if sum_amp == 0.0:
		return 0.0  # Avoid division by zero if signal is silent
	
	return weighted_sum / sum_amp
	
static func dominant_freq(
	frequencies,
	freq_min: float,
	freq_max: float,
	freq_count: int) -> float:
		
	var max_amp := 0.0
	var max_index := 0
	
	for i in range(freq_count):
		if frequencies[i] > max_amp:
			max_amp = frequencies[i]
			max_index = i
	
	# Calculate the frequency corresponding to max_index
	var freq : float = float(max_index) / freq_count * (freq_max - freq_min)
	return freq
	
static func pitch_hps(freq_data: Array, freq_min: float, freq_max: float, freq_count: int) -> float:
	var max_hps := 0.0
	var max_index := 0
	var hps := []

	var max_harmonics := 4 # You can adjust

	for i in range(freq_count):
		var product : float = freq_data[i]
		for h in range(2, max_harmonics + 1):
			var index := int(i * h)
			if index >= freq_count:
				break
			product *= freq_data[index]
		hps.append(product)
	
	for i in range(freq_count):
		if hps[i] > max_hps:
			max_hps = hps[i]
			max_index = i
	
	var pitch := float(max_index) / freq_count * (freq_max - freq_min) + freq_min
	return pitch
