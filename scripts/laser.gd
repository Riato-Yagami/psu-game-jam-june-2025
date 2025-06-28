extends Node3D
class_name Laser

@export var POS_Z = 0
@export var SPEED = 1

@export var raycast : RayCast3D

func _init():
	position = Vector3(0, 0, POS_Z)

func setAngle(note):
	var angle = note * 7 / (2 * PI)

func _process(delta: float) -> void:
	if(raycast.is_colliding() and SceneManager.game.in_game):
		SceneManager.game.player._recieve_damage(delta)
