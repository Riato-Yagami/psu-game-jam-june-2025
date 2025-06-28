extends Node

var root
var main : Node
	
var web : bool = false

func _ready() -> void:
	if(OS.get_distribution_name() == ""): web = true
	root = get_tree().root
	main = root.get_node("Main")
	
func _process(delta):
	if(Input.is_action_just_pressed("escape")):
		quit_game()
		
	#if(Input.is_action_just_pressed("mute")):
		#AudioManager.mute()
		#
	#if(Input.is_action_just_pressed("show_timer")):
		#main.get_node("ScreenMachine").level_timer.visible = !main.get_node("ScreenMachine").level_timer.visible

func quit_game():
	get_tree().quit()
