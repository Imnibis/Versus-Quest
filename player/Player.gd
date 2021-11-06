extends KinematicBody2D

const UP : Vector2 = Vector2(0, -1)

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
var velocity : Vector2 = Vector2.ZERO
var keep_direction : Vector2 = Vector2(-1, 0)
var falling : bool = false
var jumping : bool = false
var is_dead : bool = false

func _ready():
	$DashTimer.connect("timeout", self, "dash_timer_timeout")
	$DashAgain.connect("timeout", self, "can_dash_again")
	$DyingTimer.connect("timeout", self, "player_dead")
	$DashEnable.emitting = true
	$AnimatedSprite.play("Idle")

func _physics_process(delta):
	
	if is_dead:
			return
	
	velocity.y += GRAVITY
	
	if velocity.y > 20:
		falling = true
	elif velocity.y < 20:
		jumping = true
	else:
		falling = false
		jumping = false

				
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	if Input.is_action_pressed("Right"):
		velocity.x += ACCELERATION
		keep_direction.x = 1
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Walk")
	elif Input.is_action_pressed("Left"):
		velocity.x -= ACCELERATION
		keep_direction.x = -1
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Walk")
	elif falling:
		$AnimatedSprite.play("Fall")
	elif jumping:
		$AnimatedSprite.play("Jump")
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
		$AnimatedSprite.play("Idle")
	
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

########## DEATH FUNCTION

func death():
	velocity = Vector2.ZERO
	is_dead = true
	# play death animation
	$DyingEffect.emitting = true
	$DyingTimer.start(1)
	$AnimatedSprite.hide()
	$DashEnable.hide()

func player_dead():
	self.queue_free()

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
		$AnimatedSprite.play("Dash")
		var dash_node = dash_object.instance()
		dash_node.texture = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame)
		dash_node.global_position = global_position
		dash_node.flip_h = $AnimatedSprite.flip_h
		get_parent().add_child(dash_node)
	
		$DashParticules.emitting = true
	else:
		$DashParticules.emitting = false

########### damage with anything

func _on_Area2D_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.is_in_group("win"):
		PlayerVar.has_win = true
	if area.is_in_group("damage"):
		death()
		PlayerVar.is_dead = true


func _on_Area2D_body_entered(body):
	if body.is_in_group("damage"):
		death()
