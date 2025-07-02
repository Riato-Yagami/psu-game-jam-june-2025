extends Node3D
class_name LaserContainer

#const laserRes = preload("res://scenes/laser.tscn")
#
@export var laser : Laser
@export var points : Array[Node3D]
@export var laser_speed : float = 10

func set_laser_position(_delta : float, value : float):
	#print(_delta)
	var target : float = lerp(points[0].position.z,points[1].position.z,value)
	laser.position.z = lerp(laser.position.z,target,laser_speed * _delta)
#func spawnLaser():
	#var l = laserRes.instantiate()
	#add_child(l)
	#return l

#func _ready():
	#laser = spawnLaser()
