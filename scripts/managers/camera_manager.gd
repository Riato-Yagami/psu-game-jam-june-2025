extends Node3D
class_name CameraManager

@export var transition_duration : float = 1
var transition_timer = 0

@export var menu_camera : Camera3D
@export var fight_camera : Camera3D
@export var camera : Camera3D

var target : Camera3D
var start : Camera3D

func _ready():
	set_camera_menu()
	
func set_camera_menu():
	target = menu_camera
	start = fight_camera
	transition_timer = transition_duration
	
func set_camera_fight():
	target = fight_camera
	start = menu_camera
	transition_timer = transition_duration

func _process(delta: float) -> void:
	if(shake_strength > 0):
		camera.position = target.position + randomOffset()
		shake_strength -= delta * shake_fade_speed
		
	if (transition_timer > 0):
		transition_timer -= delta
		camera.position = lerp(target.position, start.position , transition_timer/transition_duration)
		camera.rotation_degrees = lerp(target.rotation_degrees, start.rotation_degrees , transition_timer/transition_duration)
	
var shake_strength : float = 0
var shake_fade_speed : float = 0.2
func apply_shake(strength : float =  0.1): shake_strength = strength
func randomOffset() -> Vector3 : return Vector3(randf_range(-shake_strength,shake_strength),randf_range(-shake_strength,shake_strength),randf_range(-shake_strength,shake_strength))
	
