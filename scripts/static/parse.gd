extends Object
class_name Parse

static func digit(val : int, digits : int = 2) -> String :
	var text : String = str(val)
	return "0".repeat(digits - text.length()) + text
	
static func enums(text : String, names: Array[String]) -> int :
	for i in range(names.size()):
		if names[i] == text:
			return i
	return -1 # _value not found
	
static func notes(frequencies, freq_max: float, freq_count: int):
	var max_amp := 0.0
	var max_index := 0
	
	for i in range(freq_count):
		if frequencies[i] > max_amp:
			max_amp = frequencies[i]
			max_index = i
	
	# Calculate the frequency corresponding to max_index
	var dominant_freq := float(max_index) / freq_count * freq_max
	
	# Convert frequency to MIDI note
	var midi : int = round(69 + 12 * log(dominant_freq / 440.0) / log(2))
	
	# Get note name
	var note_names : Array[String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
	var note : String = note_names[midi % 12]
	var octave : int = int(midi / 12) - 1
	
	return midi
