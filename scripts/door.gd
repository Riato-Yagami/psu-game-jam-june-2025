extends Node3D
class_name Door

@export var anchor : Node3D
@export var post_it_notes : PostItNotes

var door_angle = 0

var notes = Node3D

func _ready() -> void:
	close()
	
func open() -> void:
	anchor.rotation.y = - PI / 2

func close() -> void:
	anchor.rotation.y = 0

#func _on_open_button_input_signal() -> void:
	#open()
