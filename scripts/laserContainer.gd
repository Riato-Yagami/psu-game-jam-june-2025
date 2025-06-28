extends Node
class_name LaserContainer

const laserRes = preload("res://scenes/laser.tscn")


func spawnLaser(x, y, aimX, aimY):
	var laser = laserRes.instantiate()
	laser.initialize(x, y, aimX, aimY)
	add_child(laser)
