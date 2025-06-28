extends Node3D
class_name LaserContainer

const laserRes = preload("res://scenes/laser.tscn")


func spawnLaser(x, y, aimX, aimY):
	var laser = laserRes.instantiate()
	add_child(laser)
	laser.initialize(x, y, aimX, aimY)
	print("Spawn laser (", x, ",", y, ") to (", aimX, ",", aimY, ")")

func _ready():
	# TODO: remove this line
	spawnLaser(0, 0, 1, 1)
