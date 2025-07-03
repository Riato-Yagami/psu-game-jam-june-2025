extends Node

var motor_running: bool = false

func big():
	Input.start_joy_vibration(0,0.5,0.6,0.9)

func medium():
	Input.start_joy_vibration(0,0.5,0.5,0.3)
	
func small():
	Input.start_joy_vibration(0,0.1,0.5,0.1)

func tiny():
	Input.start_joy_vibration(0,0.1,0,0.1)
