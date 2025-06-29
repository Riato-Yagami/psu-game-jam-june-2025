extends RotatingButton
class_name TimeButton

func _update_turn(axis : float = 0):
	SceneManager.game.time_manager.incr_timer(axis)
	if (self.click_sound_timer <= 0):
		SoundManager.play("wheel_click")
		self.click_sound_timer = self.click_sound_cooldown
