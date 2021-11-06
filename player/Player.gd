extends KinematicBody2D

const UP = Vector2(0, -1)


export(PackedScene) var dash_object
export var DASH_SPEED = 300
export var DASH_LENGTH = 0.15
export var NO_DASH = 3
export var MAX_SPEED = 80
export var GRAVITY = 20
export var MAX_FALL_SPEED = 200
export var JUMP_FORCE = 300
export var ACCELERATION = 10

var is_dashing : bool = false
var can_dash : bool = true
var dash_direction : Vector2 = Vector2.ZERO
var velocity = Vector2.ZERO
var keep_direction = Vector2(1, 0)

func _ready():
	$DashTimer.connect("timeout", self, "dash_timer_timeout")
	$DashAgain.connect("timeout", self, "can_dash_again")

func _physics_process(delta):
	
	velocity.y += GRAVITY
	
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	if Input.is_action_pressed("Right"):
		velocity.x += ACCELERATION
		keep_direction.x = 1
	elif Input.is_action_pressed("Left"):
		velocity.x -= ACCELERATION
		keep_direction.x = -1
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = -JUMP_FORCE

	handle_dash(delta)
	move()

########## MOVE FUNCTION

func move():
	if is_dashing:
		velocity = move_and_slide(dash_direction, UP)
	else:
		velocity = move_and_slide(velocity, UP)

########## DASH FUNCTION

func dash_timer_timeout():
	is_dashing = false

func can_dash_again():
	can_dash = true
	$DashEnable.emitting = true

func get_direction_from_input():
	var move_dir = Vector2.ZERO
	move_dir.x = -Input.get_action_strength("Left") + Input.get_action_strength("Right")

	if move_dir == Vector2(0, 0):
		move_dir.x = keep_direction.x

	move_dir = move_dir.clamped(1)	
	# WHEN ANIMATION
	
	#if move_dir == Vector2(0, 0):
	#	if $animation.flip_h:
	#		move_dir.x = -1
	#	else:
	#		move_dir.x = 1
	
	return move_dir * DASH_SPEED

func handle_dash(delta):
	if Input.is_action_pressed("dash") and can_dash:
		is_dashing = true
		can_dash = false
		dash_direction = get_direction_from_input()
		$DashTimer.start(DASH_LENGTH)
		$DashAgain.start(NO_DASH)
		$DashEnable.emitting = false
		
	if is_dashing:
		var dash_node = dash_object.instance()
		dash_node.texture = $Sprite.texture
		dash_node.global_position = global_position
		#dash_node.flip_h = $animation.flip_h
		get_parent().add_child(dash_node)
	
		$DashParticules.emitting = true
	else:
		$DashParticules.emitting = false
