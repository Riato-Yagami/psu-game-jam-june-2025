extends Node
class_name PanelButtons

@export var buttons : Array[PanelButton]
@export var time_button : RotatingButton
@export var wave_button : WaveButton
#var button_id : int = 0
var current_button_id = 1

func _ready() -> void:
	select_button(current_button_id)
	
func select_button(id : int) -> void :
	wave_button.un_select()
	buttons[current_button_id].un_select()
	buttons[id].select()
	current_button_id = id

func press_button() -> void :
	if(buttons[current_button_id].hand_sprite.visible):
		buttons[current_button_id].press()
	
func hide_hand() -> void :
	buttons[current_button_id].un_select()
	wave_button.select()
	
func _process(delta: float) -> void:
	if(!SceneManager.game.in_game):
		_update_button_selection()
		
func _update_button_selection():
	var axis : int = 1 if Input.is_action_just_pressed("move_down") else  (-1 if Input.is_action_just_pressed("move_up") else 0)
	if(axis!=0):
		var id = current_button_id
		id += axis
		id = clampi(id,0,buttons.size()-1)
		select_button(id)
	if(Input.is_action_just_pressed("action")):
		press_button()
#func _press_button():
	
