extends Node
class_name TimeManager

var timeButton : RotatingButton
@export var game : GameManager
var level_timer : LevelTimer

var time : float = 0
var timer = 0
var default_time = 30

var MAX = 30 * 60
var MIN = 10

func _ready() -> void:
	timeButton = game.microwave.panel_buttons.time_button
	level_timer = game.microwave.level_timer
	update_timer_button()
	#timeButton.angle = timer
	
func reset_timer():
	timer = default_time
	update_timer_button()
	
func _process(delta: float) -> void:
	if(game.in_game): update_timer(delta)

func update_timer(delta: float) -> void:
	timer -= delta
	
	if(timer < 0):
		level_timer.pause()
		game.game_over(true)
		
	update_timer_button()
	
func start_timer():
	timeButton.angle = timer
	level_timer.start(timer)
	
func update_timer_button():
	#timeButton.angle = timer * (60/35)
	if(!timeButton): timeButton = game.microwave.panel_buttons.time_button
	timeButton.angle = timer / (3.1 * 2)
	
func incr_timer(value):
	timer += value
	timer = clamp(timer,MIN,MAX)
	#print(timer)
	update_timer_button()
