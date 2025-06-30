extends Node3D
class_name LevelTimer

@onready var clock : Clock = Clock.new()
@export var hms_label : Label3D
@export var ms_label : Label

func _ready():
	add_child(clock)
	#start(1000)

func start(time : float):
	clock.time = time
	clock.reverse = true
	clock.enabled = true
	
func pause():
	clock.enabled = false
	
func _process(_delta):
	if(!clock.enabled or clock.time < 0) : return
	var w : Watch = clock.sort()
	var text : String = w.pm + ":" + w.ps
	#var text : String = w.ph + ":" + w.pm + ":" + w.ps
	#print(text, "." + w.pms)
	hms_label.text = text
	if(ms_label) : ms_label.text = "." + w.pms
