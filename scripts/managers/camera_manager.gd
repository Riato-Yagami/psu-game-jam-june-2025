extends Node3D

@export var transition_duration : float = 1
var transition_timer = 0

var menu_position : Vector3
var menu_rotation : Vector3
@export var fight_position : Vector3
@export var fight_rotation : Vector3

var start_position : Vector3
var start_rotation : Vector3
var target_position : Vector3
var target_rotation : Vector3

func _ready():
	menu_position = $Camera3D.position
	menu_rotation = $Camera3D.rotation_degrees

func set_camera_menu():
	start_position = $Camera3D.position
	start_rotation = $Camera3D.rotation_degrees
	target_position = menu_position
	target_rotation = menu_rotation
	transition_timer = transition_duration
	
func set_camera_fight():
	start_position = $Camera3D.position
	start_rotation = $Camera3D.rotation_degrees
	target_position = fight_position
	target_rotation = fight_rotation
	transition_timer = transition_duration

func _process(delta: float) -> void:
	if (transition_timer <= 0):
		return
	transition_timer -= delta
	$Camera3D.position = lerp(target_position, start_position , transition_timer/transition_duration)
	$Camera3D.rotation_degrees = lerp(target_rotation ,start_rotation , transition_timer/transition_duration)
