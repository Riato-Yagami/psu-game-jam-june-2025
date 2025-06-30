extends RotatingButton
class_name LaserAngleButton


func _update_turn(axis : float = 0):
	var laserContainer = SceneManager.get_node("Main/Game/LaserContainer")
	#print("laserContainer")
	#laserContainer.laser.setAngle(note)
