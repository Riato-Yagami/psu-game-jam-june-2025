extends Node3D
class_name GameManager

var tcp := StreamPeerTCP.new()

@export var microwave : Microwave
@export var time_manager : TimeManager
var player : Player

var in_game : bool = false
signal on_game_start
signal on_game_over

func _ready() -> void:
	time_manager.reset_timer()
	player = microwave.plate.player
	
func _process(delta: float) -> void:
	pass
	#if(Input.is_action_just_pressed("move_left")):
		#game_over()
		
func start_game():
	time_manager.start_timer()
	microwave.door.open()
	microwave.panel_buttons.hide_hand()
	$CameraNode.set_camera_fight()
	in_game = true
	SoundManager.play("beep")
	emit_signal("on_game_start")
	#connect_audio()
		
func game_over(player_win : bool = true):
	emit_signal("on_game_over")
	time_manager.reset_timer()
	in_game = false
	microwave.door.post_it_notes.get_node("Tutorial").visible = false
	microwave.door.post_it_notes.get_node("PastaWin").visible = player_win
	microwave.door.post_it_notes.get_node("CookerWin").visible = !player_win
	microwave.door.close()
	$CameraNode.set_camera_menu()
	#microwave.panel_buttons.select_button(microwave.panel_buttons.current_button_id)

#func connect_audio():
	#var err = tcp.connect_to_host("127.0.0.1", 12345)
	#if err != OK:
		#print("Erreur de connexion :", err)
	#else:
		#print("Connexion demandée…")

func _input(event):
	if event is InputEventMouseButton:
		var laserContainer = $LaserContainer
		var laser = laserContainer.laser
		
		if not laser:
			return
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			laserContainer.laser.scrollWayUp()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			laserContainer.laser.scrollWayDown()
