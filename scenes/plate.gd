extends Sprite3D
class_name Plate

@export var rotation_speed : float = 1.0

func _process(delta: float) -> void:
	rotate(Vector3.UP,rotation_speed * delta)
	
