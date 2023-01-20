extends KinematicBody2D

class_name Actor

export(String) var ACTOR_NAME = "Actor"
export(int) var LEVEL = 1
export(int) var MAX_HP = 10
export(int) var ATTACK = 1
export(int) var DEFENSE = 1
export(int) var MAGIC = 1

export(int) var ACCELERATION = 100
export(int) var FRICTION = 200
export(int) var MAX_SPEED = 600

var velocity = Vector2.ZERO
var HP = MAX_HP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_friction(input, delta):
	if input.x == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	if input.y == 0:
		velocity.y = move_toward(velocity.y, 0, FRICTION * delta)
	
func apply_acceleration(input, delta):
	if sign(input.x) + sign(velocity.x) == 0:
		velocity.x += FRICTION * delta * input.x
	else:
		velocity.x += ACCELERATION * delta * input.x
	if sign(input.y) + sign(velocity.y) == 0:
		velocity.y += FRICTION * delta * input.y
	else:
		velocity.y += ACCELERATION * delta * input.y
	if velocity.x > MAX_SPEED:
		velocity.x = MAX_SPEED
	if velocity.y > MAX_SPEED:
		velocity.y = MAX_SPEED
