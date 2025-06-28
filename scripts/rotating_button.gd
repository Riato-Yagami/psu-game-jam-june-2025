extends PanelButton
class_name RotatingButton

var angle : float :
	set(_value) : sprite.rotation.z = _value / 180 * PI
	get : return sprite.rotation.z
