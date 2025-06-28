extends Node3D
class_name LaserContainer

const laserRes = preload("res://scenes/laser.tscn")


func spawnLaser(x, y, aimX, aimY):
	var laser = laserRes.instantiate()
	laser.initialize(x, y, aimX, aimY)
	add_child(laser)

func _ready():
	spawnLaser(0, 0, 1, 1)
