extends Node
class_name TargetPoint

var x
var y
var controlX
var controlY


func _init(_x, _y):
	x = _x
	y = _y
	

static func interpolate(a: TargetPoint, b: TargetPoint, pos: float) -> Vector2:
	var dx = b.x - a.x
	var dy = b.y - a.y
	var dist = sqrt(dx*dx + dy*dy) * pos
	return Vector2(
		a.x + dx*dist,
		a.y + dy*dist
	)
	
