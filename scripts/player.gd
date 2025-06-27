extends CharacterBody3D
class_name Player

@export var plate : Plate

var direction : Vector2
@export var speed : float = 1

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_right","move_left","move_down","move_up")
	#print("direction = ",direction)
	var angle : float = plate.get_angle()
	#print("angle = ",angle)
	var rotated_dir : Vector2 = Vector2(direction.x * cos(angle) - direction.y * sin(angle),
	direction.x * sin(angle) + direction.y * cos(angle))
	#print("rotated_dir = ",rotated_dir)
	position += Vector3(rotated_dir.x,rotated_dir.y,0) * delta * speed
	if(position.distance_to(Vector3.ZERO) > plate.RADIUS) :
		position = position.normalized() * plate.RADIUS
