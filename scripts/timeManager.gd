extends Node
class_name TimeManager

var timeButton : RotatingButton
@export var game : GameManager

var time : float = 0
var timer = 1.5 * 60

var MAX = 30 #min

func _ready() -> void:
	timeButton = game.microwave.panel_buttons.time_button
	update_timer_button()
	#timeButton.angle = timer
	
func _process(delta: float) -> void:
	if(game.in_game): update_timer(delta)

func update_timer(delta: float) -> void:
	timer -= delta
	update_timer_button()
	
func start_timer():
	timeButton.angle = timer
	pass
	
func update_timer_button():
	#timeButton.angle = timer * (60/35)
	timeButton.angle = timer / 2.75
