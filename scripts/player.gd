extends CharacterBody3D
class_name Player

@export var plate : Plate

var direction : Vector2
@export var speed : float = 1
@export var runThreshold : float = 0.2
@export var currentHealth : float = 1
@export var maxHealth : float = 10
#@export var active : bool

func _ready():
	SceneManager.game.on_game_start.connect(_reset_player)

func _reset_player():
	currentHealth = maxHealth
	#active = true

func _physics_process(delta: float) -> void:
	if (!SceneManager.game.in_game):
		return
	
	direction = Input.get_vector("move_right","move_left","move_down","move_up")
	#print("direction = ",direction)
	var angle : float = plate.get_angle()
	#print("angle = ",angle)
	var rotated_dir : Vector2 = Vector2(direction.x * cos(angle) - direction.y * sin(angle),
	direction.x * sin(angle) + direction.y * cos(angle))
	#print("rotated_dir = ",rotated_dir)
	var movementForce = Vector3(rotated_dir.x,0,rotated_dir.y) * speed
	position += movementForce * delta
	#$AnimationTree.set("parameters/conditions/idleToRun", movementForce.length() > runThreshold);
	if (movementForce.length() > runThreshold):
		$AnimationPlayer.play("Run")
		var target_angle = atan2(movementForce.x, movementForce.z)
		rotation.y = target_angle
		#self.rotation_degrees = Vector3(self.rotation_degrees.x, self.rotation_degrees.y - angle, self.rotation_degrees.z)
	else:
		$AnimationPlayer.play("Idle")
	#$AnimationTree.set("parameters/conditions/runToIdle", movementForce.length() < runThreshold);
	if(position.distance_to(Vector3.ZERO) > plate.radius) :
		position = position.normalized() * plate.radius
	
	_recieve_damage(delta)
	#rotation = angle 

func _recieve_damage(value: float) -> void:
	currentHealth -= value
	if (currentHealth <= 0):
		#active = false
		SceneManager.game.game_over(false)
