extends Node3D
class_name LaserContainer

const laserRes = preload("res://scenes/laser.tscn")

var laser = null


func spawnLaser():
	var l = laserRes.instantiate()
	add_child(l)
	return l

func _ready():
	laser = spawnLaser()
