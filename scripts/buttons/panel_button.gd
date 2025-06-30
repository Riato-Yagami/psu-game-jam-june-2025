extends Node3D
class_name PanelButton

@onready var sprite : Sprite3D = $Sprite
@onready var hand : Node3D = $Hand
@onready var hand_sprite : Sprite3D = $Hand/Sprite
signal input_signal

#func _ready() -> void:
	#_on_press()
	
func _press():
	pass
	
func press():
	_press()
	#input_signal.emit()

func un_select():
	hand_sprite.visible = false

func select():
	hand_sprite.visible = true
