extends RotatingButton
class_name TimeButton

func _update_turn(axis : float = 0):
	SceneManager.game.time_manager.incr_timer(axis)
