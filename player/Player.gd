extends KinematicBody2D

const UP = Vector2(0, -1)

export var MAX_SPEED = 80
export var GRAVITY = 20
export var MAX_FALL_SPEED = 200
export var JUMP_FORCE = 300
export var ACCELERATION = 10

var velocity = Vector2.ZERO

var dash_direction = Vector2(1, 0)
var dashing = false

func _physics_process(delta):
	
	velocity.y += GRAVITY
	
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += ACCELERATION
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= ACCELERATION
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = -JUMP_FORCE
	dash()
	
	velocity = move_and_slide(velocity, UP)

func dash():
	if dashing:
		return
	
	if Input.is_action_pressed("ui_right"):
		dash_direction = Vector2(1, 0)
	if Input.is_action_just_pressed("ui_left"):
		dash_direction = Vector2(-1, 0)
	
	if Input.is_action_just_pressed("dash"):
		velocity = dash_direction.normalized() * 2000
		dashing = true
		yield(get_tree().create_timer(3), "timeout")
		dashing = false
