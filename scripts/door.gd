extends Node3D
class_name Door

@export var anchor : Node3D
@export var post_it_notes : PostItNotes
@export var open_close_duration : float = 1
var open_timer : float
var close_timer : float

#var door_angle = 0

var notes = Node3D

#func _ready() -> void:
	#close()

func _process(delta: float) -> void:
	if (open_timer > 0):
		open_timer -= delta
		anchor.rotation.y = lerp(- PI / 2, 0.0, open_timer/open_close_duration)
		if (open_timer <= 0):
			anchor.rotation.y = - PI / 2
	else: if (close_timer > 0):
		close_timer -= delta
		anchor.rotation.y = lerp(0.0, - PI / 2, close_timer/open_close_duration)
		if(close_timer <= 0.5):
			SceneManager.game.player.mesh_parent.visible = false
		if (close_timer <= 0):
			anchor.rotation.y = 0
			SoundManager.play("door_close")
			SceneManager.game.microwave.panel_buttons.select_button(SceneManager.game.microwave.panel_buttons.current_button_id)
	
func open() -> void:
	open_timer = open_close_duration
	SoundManager.play("door_open")

func close() -> void:
	close_timer = open_close_duration

#func _on_open_button_input_signal() -> void:
	#open()
