extends Node
class_name TimeManager

var timeButton : RotatingButton
@export var game : GameManager

var time : float = 0
var timer = 0.1 * 60

var MAX = 30 * 60
var MIN = 0

func _ready() -> void:
	timeButton = game.microwave.panel_buttons.time_button
	update_timer_button()
	#timeButton.angle = timer
	
func _process(delta: float) -> void:
	if(game.in_game): update_timer(delta)

func update_timer(delta: float) -> void:
	timer -= delta
	
	if(timer < 0):
		game.game_over(true)
		
	update_timer_button()
	
func start_timer():
	timeButton.angle = timer
	pass
	
func update_timer_button():
	#timeButton.angle = timer * (60/35)
	if(!timeButton): timeButton = game.microwave.panel_buttons.time_button
	timeButton.angle = timer / (3.1 * 2)
	
func incr_timer(value):
	timer += value
	timer = clamp(timer,MIN,MAX)
	#print(timer)
	update_timer_button()
