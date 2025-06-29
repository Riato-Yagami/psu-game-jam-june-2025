extends Node3D
class_name Laser

@export var POS_Z = 0
@export var SPEED = 1
@export var DRAG = .8

@export var raycast : RayCast3D
var pshhCooldown : float = 0.3
var pshhTimer : float = 0


const SCROLL_WAY_SPEED = PI/15
const SCROLL_WAY_MAX_SPEED = 5 * SCROLL_WAY_SPEED
const SCROLL_AIM_SPEED = PI/2

var scrollWay = 0
var scrollAim = 0
var useScrollWay = true

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

func _process(delta: float) -> void:
	if useScrollWay:
		rotation.y += scrollWay * delta
		scrollWay *= DRAG
		if(raycast.is_colliding() and SceneManager.game.in_game):
			pshh(delta)
			SceneManager.game.player._recieve_damage(delta)
	
	else:
		rotation.y += (scrollAim - rotation.y) * delta * SCROLL_AIM_SPEED
	

func pshh(delta):
	if(pshhTimer > 0) :
		pshhTimer -= delta
		return
	SoundManager.play("pshh")
	pshhTimer = pshhCooldown
