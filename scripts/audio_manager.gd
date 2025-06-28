extends Node

var tcp := StreamPeerTCP.new()
var is_connected := false
var time_passed := 0.0

func _ready():
	var is_windows := OS.get_name() == "Windows"
	var script := ProjectSettings.globalize_path(
		"res://launch.bat" if is_windows else "res://launch.sh"
	)
	var interpreter := "cmd" if is_windows else "bash"
	var args := ["/C", script] if is_windows else [script]

	var result := OS.create_process(interpreter, args)
	if result == -1:
		push_error("Échec du lancement du serveur Python.")
	else:
		print("Serveur Python lancé.")



func _process(delta):
	tcp.poll()

	if not is_connected and tcp.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		is_connected = true
		print("Connecté au serveur Python.")

	if is_connected:
		time_passed += delta
		if time_passed >= 1.0:
			time_passed = 0.0
			var message = "ping\n"
			var err = tcp.put_data(message.to_utf8_buffer())
			if err == OK:
				print("Message envoyé :", message.strip_edges())
			else:
				print("Erreur d'envoi :", err)

		if tcp.get_available_bytes() > 0:
			var response = tcp.get_utf8_string(tcp.get_available_bytes())
			var note = float(response.strip_edges())
			setLaserAngle(note)


func setLaserAngle(note):
	var laserContainer = SceneManager.get_node("Main/Game/LaserContainer")
	laserContainer.laser.setAngle(note)
	
