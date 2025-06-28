extends Node3D
class_name LaserContainer

const laserRes = preload("res://scenes/laser.tscn")

var laser = null


func spawnLaser(x, y, aimX, aimY):
	var laser = laserRes.instantiate()
	add_child(laser)
	print("Spawn laser (", x, ",", y, ") to (", aimX, ",", aimY, ")")

func _ready():
	laser = spawnLaser(0, 0, 0, 1)
