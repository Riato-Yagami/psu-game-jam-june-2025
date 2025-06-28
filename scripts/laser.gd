extends Node3D
class_name Laser


@export var POS_Z = 0
@export var SPEED = 1

func _init():
	position = Vector3(0, 0, POS_Z)


func setAngle(note):
	var angle = note * 7/6.28318530718
	
	
	
