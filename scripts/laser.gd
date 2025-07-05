extends Node3D
class_name Laser

@export var POS_Z = 0
@export var SPEED = 1
@export var DRAG = .8

@export var raycast : RayCast3D
@export var target : Node3D
@export var meshAnchor : Node3D

@export var laser_container : LaserContainer

var deployement : float = 0
@export var deployement_speed : float = 1.0
@export var deployement_delay : float = 0.75

var pshhCooldown : float = 0.3
var pshhTimer : float = 0

const SCROLL_WAY_SPEED = PI/6
const SCROLL_WAY_MAX_SPEED = 5 * SCROLL_WAY_SPEED
const SCROLL_AIM_SPEED = PI/2

var scrollWay = 0
var scrollAim = 0
@export var useScrollWay = true

func _init():
	position = Vector3(0, 0, POS_Z)


func setAngle(a):
	useScrollWay = false
	scrollWay = 0
	scrollAim = a

func scrollWayUp():
	scrollWay += SCROLL_WAY_SPEED
	if scrollWay > SCROLL_WAY_MAX_SPEED:
		scrollWay = SCROLL_WAY_MAX_SPEED
	
func scrollWayDown():
	scrollWay -= SCROLL_WAY_SPEED
	if scrollWay < -SCROLL_WAY_MAX_SPEED:
		scrollWay = -SCROLL_WAY_MAX_SPEED

func reset():
	deployement = 0
	meshAnchor.scale.x = 0.001
	raycast.target_position.x = 0
	
func deploy(delta: float):
	if(deployement > deployement_delay):
		meshAnchor.scale.x = deployement - deployement_delay
		raycast.target_position.x = lerp(
			0.0,
			target.global_position.x - raycast.global_position.x,
			deployement - deployement_delay
		)
	deployement += deployement_speed * delta
	
func _process(delta: float) -> void:
	if(deployement < deployement_delay + 1 and SceneManager.game.in_game):
		deploy(delta)
	
	if useScrollWay:
		position.z += scrollWay * delta
		position.z = clamp(position.z, laser_container.points[0].position.z,laser_container.points[1].position.z)
	#if useScrollWay:
		#rotation.y += scrollWay * delta
		#scrollWay *= DRAG
	#else:
		#rotation.y += (scrollAim - rotation.y) * delta * SCROLL_AIM_SPEED
	
	if (raycast.is_colliding() and SceneManager.game.in_game):
		pshh(delta)
		SceneManager.game.player._recieve_damage(delta)

func pshh(delta):
	if(pshhTimer > 0) :
		pshhTimer -= delta
		return
	SoundManager.play("pshh")
	pshhTimer = pshhCooldown
