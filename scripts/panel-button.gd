extends Node3D
class_name PanelButton

@onready var sprite : Sprite3D = $Sprite

signal input_signal

func _ready() -> void:
	_on_press()
	
func _on_press():
	input_signal.emit()
