extends Node

var mic_capture: AudioEffectCapture
var pitch_history = []
const MAX_HISTORY = 5

func _ready():
	# Configure micro et bus audio "Record" dans le projet Godot
	var mic_stream = AudioStreamMicrophone.new()
	var mic_player = AudioStreamPlayer.new()
	mic_player.name = "MicPlayer"
	mic_player.stream = mic_stream
	mic_player.bus = "Record"
	add_child(mic_player)
	mic_player.play()
	
	mic_capture = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 0)


func _process(_delta):
	if mic_capture and mic_capture.get_frames_available() >= 1024:
		var audio_data = mic_capture.get_buffer(1024)  # PackedVector2Array stereo
		var samples = PackedFloat32Array()
		for v in audio_data:
			samples.append(v.x)  # canal gauche mono

		var sample_rate = AudioServer.get_mix_rate()
		var raw_pitch = detect_pitch(samples, sample_rate)
		var corrected_pitch = correct_harmonics(raw_pitch, 80, 1000)
		var smooth = smooth_pitch(corrected_pitch)
		
		if smooth > 0:
			print("Pitch détecté (Hz) : ", smooth)


# --- Algorithme YIN ---
func detect_pitch(samples: PackedFloat32Array, sample_rate: int) -> float:
	var threshold = 0.15
	var min_freq = 80
	var max_freq = 400
	var min_lag = int(sample_rate / max_freq)
	var max_lag = int(sample_rate / min_freq)
	var size = samples.size()

	var d = []
	d.resize(max_lag + 1)
	for tau in range(min_lag, max_lag + 1):
		var sum = 0.0
		for i in range(size - tau):
			var diff = samples[i] - samples[i + tau]
			sum += diff * diff
		d[tau] = sum

	var d_prime = []
	d_prime.resize(max_lag + 1)
	d_prime[0] = 1.0

	var cumulative_sum = 0.0
	for tau in range(min_lag, max_lag + 1):
		cumulative_sum += d[tau]
		if cumulative_sum > 0:
			d_prime[tau] = d[tau] * tau / cumulative_sum
		else:
			d_prime[tau] = 1.0

	for tau in range(min_lag, max_lag):
		if d_prime[tau] < threshold and d_prime[tau] < d_prime[tau + 1]:
			var better_tau = parabolic_interpolation(d_prime, tau)
			return sample_rate / better_tau

	return -1.0

func parabolic_interpolation(d_prime: Array, tau: int) -> float:
	var x0 = tau - 1 if tau > 0 else tau
	var x1 = tau
	var x2 = tau + 1 if tau < d_prime.size() - 1 else tau

	var y0 = d_prime[x0]
	var y1 = d_prime[x1]
	var y2 = d_prime[x2]

	var denom = (y0 - 2 * y1 + y2)
	if denom == 0:
		return float(tau)

	var delta = 0.5 * (y0 - y2) / denom
	return float(tau) + delta


# --- Correction harmonique ---
func correct_harmonics(freq: float, min_freq: float = 80.0, max_freq: float = 1000.0) -> float:
	if freq <= 0.0:
		return -1.0

	var corrected = freq
	for mult in [2, 3, 4]:
		var candidate = freq * mult
		if candidate <= max_freq and candidate >= min_freq:
			corrected = candidate
	return corrected


# --- Lissage simple ---
func smooth_pitch(new_pitch: float) -> float:
	if new_pitch < 0:
		return -1.0
	pitch_history.append(new_pitch)
	if pitch_history.size() > MAX_HISTORY:
		pitch_history.pop_front()

	var sum = 0.0
	for p in pitch_history:
		sum += p
	return sum / pitch_history.size()
