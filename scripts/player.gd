extends CharacterBody3D
class_name Player

@export var plate : Plate

var direction : Vector2
@export var speed : float = 1
@export var runThreshold : float = 0.2
@export var currentHealth : float = 1
@export var maxHealth : float = 10
#@export var active : bool

@export var jumpWindupDuration : float = 0.01
@export var jumpInvincibleDuration : float = .7
@export var jumpRecoveryDuration : float = .05
@export var jumpCooldownDuration : float = 0.25

@export var inJump : bool

var jumpWindupTimer: float
var jumpInvincibleTimer: float
var jumpRecoveryTimer: float
var jumpCooldownTimer: float

var walkCoolDown = 0.3
var walkCoolDownTimer = 0

@export var maxSmokeParticles : int = 8

#var smokeParticlesMaterial : ParticleProcessMaterial

func _ready():
	SceneManager.game.on_game_start.connect(_reset_player)
	#smokeParticlesMaterial = $GPUParticles3D.process_material as ParticleProcessMaterial 

func _reset_player():
	currentHealth = maxHealth
	inJump = false
	$CollisionShape3D.disabled = false
	$GPUParticles3D.amount_ratio = 0
	#active = true

func footStep(delta):
	if(walkCoolDownTimer > 0) :
		walkCoolDownTimer -= delta
		return
	SoundManager.play("footstep/1")
	walkCoolDownTimer = walkCoolDown
	
func _physics_process(delta: float) -> void:
	if (!SceneManager.game.in_game):
		return
		
	if (Input.is_action_just_pressed("action")):
		_try_jump()
	
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
		if (!inJump):
			footStep(delta)
			$AnimationPlayer.play("Run")
		var target_angle = atan2(movementForce.x, movementForce.z)
		rotation.y = target_angle
		#self.rotation_degrees = Vector3(self.rotation_degrees.x, self.rotation_degrees.y - angle, self.rotation_degrees.z)
	else: if (!inJump) :
		$AnimationPlayer.play("Idle")
	#$AnimationTree.set("parameters/conditions/runToIdle", movementForce.length() < runThreshold);
	if(position.distance_to(Vector3.ZERO) > plate.radius) :
		position = position.normalized() * plate.radius
	
	if (jumpWindupTimer > 0):
		jumpWindupTimer -= delta
		if (jumpWindupTimer <= 0):
			jumpInvincibleTimer = jumpInvincibleDuration
			SoundManager.play("jump2")
			$CollisionShape3D.disabled = true
	else: if (jumpInvincibleTimer > 0):
		jumpInvincibleTimer -= delta
		if (jumpInvincibleTimer <= 0):
			jumpRecoveryTimer = jumpRecoveryDuration
			$CollisionShape3D.disabled = false
	else: if (jumpRecoveryTimer > 0):
		jumpRecoveryTimer -= delta
		if (jumpRecoveryTimer <= 0):
			jumpCooldownTimer = jumpCooldownDuration
			inJump = false
	else: if (jumpCooldownTimer > 0):
		jumpCooldownTimer -= delta
		if (jumpCooldownTimer <= 0):
			jumpCooldownTimer = 0
	
	#_recieve_damage(delta)
	#rotation = angle 

func _recieve_damage(value: float) -> void:
	currentHealth -= value
	#$GPUParticles3D.amount_ratio = maxSmokeParticles * (1 - currentHealth / maxHealth)
	$GPUParticles3D.amount_ratio = (1 - currentHealth / maxHealth)
	if (currentHealth <= 0):
		#active = false
		$AnimationPlayer.play("Death")
		SceneManager.game.game_over(false)

func _try_jump():
	if (!inJump && jumpCooldownTimer <= 0):
		$AnimationPlayer.play("Idle")
		$AnimationPlayer.play("Jump")
		#print("jump")
		inJump = true
		jumpWindupTimer = jumpWindupDuration
