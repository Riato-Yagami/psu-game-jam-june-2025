extends Node3D
class_name GameManager

var tcp := StreamPeerTCP.new()

@export var microwave : Microwave
@export var time_manager : TimeManager
var player : Player

var in_game : bool = false
signal on_game_start

func _ready() -> void:
	player = microwave.plate.player
	
func _process(delta: float) -> void:
	pass
	#if(Input.is_action_just_pressed("move_left")):
		#game_over()
		
func start_game():
	time_manager.start_timer()
	microwave.door.open()
	microwave.panel_buttons.hide_hand()
	in_game = true
	SoundManager.play("beep")
	emit_signal("on_game_start")
	connect_audio()
		
func game_over(player_win : bool = true):
	in_game = false
	microwave.door.post_it_notes.get_node("PlayerWin").visible = player_win
	microwave.door.post_it_notes.get_node("CookerWin").visible = !player_win
	microwave.door.close()
	microwave.panel_buttons.select_button(microwave.panel_buttons.current_button_id)
	
func connect_audio():
	var err = tcp.connect_to_host("127.0.0.1", 12345)
	if err != OK:
		print("Erreur de connexion :", err)
	else:
		print("Connexion demandée…")
