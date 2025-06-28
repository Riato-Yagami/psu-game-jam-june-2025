extends Node3D
class_name Plate

@export var rotation_speed : float = 1.0
@export var microwave : Microwave

@export var plate_dimensions : Dimensions

var radius : float : 
	get : return plate_dimensions.width / 100 # inputed as mm

func _process(delta: float) -> void:
	#return
	rotate(Vector3.UP,rotation_speed * delta)
	
func get_angle() -> float:
	return rotation.y
