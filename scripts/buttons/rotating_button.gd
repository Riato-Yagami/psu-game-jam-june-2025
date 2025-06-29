extends PanelButton
class_name RotatingButton

var click_sound_timer : float
@export var click_sound_cooldown : float = 0.1

@export var rotating_speed : float = 300
var angle : float :
	set(_value) : sprite.rotation.z = _value / 180 * PI
	get : return sprite.rotation.z

func _ready() -> void:
	_update_turn(0)
	
func _process(delta: float) -> void:
	if (not hand_sprite) or hand_sprite.visible:
		var axis : int = 1 if Input.is_action_pressed("move_right") else  (-1 if Input.is_action_pressed("move_left") else 0)
		if(axis != 0):
			_update_turn(axis * delta * rotating_speed)
	if (click_sound_timer > 0):
		click_sound_timer -= delta
		
func _update_turn(axis : float = 0):
	return
