extends Node3D
class_name Plate

@export var rotation_speed : float = 1.0
@export var rotation_speed_change : float = 1.0
@export var target_rotation_speed : float = 1.0
@export var microwave : Microwave

@export var phase_target_speeds : Array[float] = []
@export var phase_durations : Array[float] = []
@export var phase_audio_strings : Array[String] = []

var phase_options_count : int
var duration_timer : float
@export var transition_duration : float = 1.5
var transition_timer : float

@export var plate_dimensions : Dimensions
@export var player : Player

var rng = RandomNumberGenerator.new()

var radius : float : 
	get : return plate_dimensions.width / 2 / 100 # inputed as mm

func _ready():
	SceneManager.game.on_game_start.connect(_set_phase_start)
	phase_options_count = phase_target_speeds.size()
	rng.randomize()  # Seeds the generator with a random value
	
func _set_phase_start():
	_set_phase(0)

func _set_phase(index: int):
	duration_timer = phase_durations[index] - 0.5
	if (target_rotation_speed > 0):
		target_rotation_speed = - phase_target_speeds[index]
	else:
		target_rotation_speed = phase_target_speeds[index]
	SoundManager.play(phase_audio_strings[index], 1, 1, duration_timer)

func _process(delta: float) -> void:
	if (!SceneManager.game.in_game):
		return
	
	if (rotation_speed < target_rotation_speed):
		rotation_speed += rotation_speed_change
		if (rotation_speed > target_rotation_speed):
			rotation_speed = target_rotation_speed
	else: if (rotation_speed > target_rotation_speed):
		rotation_speed -= rotation_speed_change
		if (rotation_speed < target_rotation_speed):
			rotation_speed = target_rotation_speed
	
	if (duration_timer > 0):
		duration_timer -= delta
		if (duration_timer <= 0):
			transition_timer = transition_duration
			SoundManager.play("rewind", 1, 1, 0)
			
	if (transition_timer > 0):
		transition_timer -= delta
		if (transition_timer <= 0):
			_set_phase(rng.randi_range(1, phase_options_count - 1))
	
	#return
	rotate(Vector3.UP,rotation_speed * delta)
	
func get_angle() -> float:
	return rotation.y
