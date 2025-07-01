extends AudioStreamPlayer
class_name Sound

var id : String

func play_clip(clip, time = 0):
	var c = load(clip)
	#print("Clip : ",clip," - Audio : ",c)
	stream = load(clip)
	#if stream == null:
		#push_error(clip," failed to load!")
	play()
	
	if(time != 0):
		await get_tree().create_timer(time).timeout
		queue_free()

func _on_finished():
	queue_free()
