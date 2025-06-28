extends Node3D
class_name Laser


@export var POS_Z = 0
@export var SPEED = 1

var velocity: Vector3
var spawnPosition: Vector3

func _init():
	pass


func initialize(x, y, aimX, aimY):
	position = Vector3(x, y, POS_Z)
	spawnPosition = Vector3(x, y, POS_Z)
	
	# Define target
	var dir = Vector3(aimX - x, aimY - y, 0).normalized()
	velocity = dir * SPEED
	
	# Look at target
	var target = Vector3(aimX, aimY, 0)
	look_at(target, Vector3.UP)

func _physics_process(delta):
	position += velocity * delta
	
