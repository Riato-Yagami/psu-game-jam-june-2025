extends Node3D
class_name Plate

@export var rotation_speed : float = 1.0
const RADIUS = 0.5

func _process(delta: float) -> void:
	#return
	rotate(Vector3.UP,rotation_speed * delta)
	
func get_angle() -> float:
	return rotation.y
