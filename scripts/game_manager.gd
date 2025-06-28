extends Node3D
class_name GameManager

@export var microwave : Microwave
@export var time_manager : TimeManager

var in_game : bool = false

func _process(delta: float) -> void:
	pass
	#if(Input.is_action_just_pressed("move_left")):
		#game_over()
		
func start_game():
	time_manager.start_timer()
	microwave.door.open()
	microwave.panel_buttons.hide_hand()
	in_game = true
		
func game_over(player_win : bool = true):
	in_game = false
	microwave.door.post_it_notes.get_node("PlayerWin").visible = player_win
	microwave.door.post_it_notes.get_node("CookerWin").visible = !player_win
	microwave.door.close()
	microwave.panel_buttons.select_button(microwave.panel_buttons.current_button_id)
	
