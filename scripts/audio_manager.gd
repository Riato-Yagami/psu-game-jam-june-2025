extends Node

var tcp := StreamPeerTCP.new()
var is_connected := false
var time_passed := 0.0

func _ready():
	var err = tcp.connect_to_host("127.0.0.1", 12345)
	if err != OK:
		print("Erreur de connexion :", err)
	else:
		print("Connexion demandée…")

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
	print(note)
	
	
	
	
	
