extends KinematicBody2D

const UP : Vector2 = Vector2(0, -1)

export var MAX_SPEED = 80.0
export var GRAVITY = 20.0
export var MAX_FALL_SPEED = 200.0
export var FALL_MULTIPLIER = 2.5
export var LOW_JUMP_MULTIPLIER = 3
export var ACCELERATION = 10.0
export var JUMP_FORCE = 300.0
export var RISING_MIDDLE_JUMP_THRESHHOLD = 30.0
export var FALLING_MIDDLE_JUMP_THRESHHOLD = 30.0

var velocity : Vector2 = Vector2.ZERO
var keep_direction : Vector2 = Vector2(-1, 0)
var dead = false

func _ready():
	$DyingTimer.connect("timeout", self, "free")
	$DyingTimer2.connect("timeout", self, "disappear")
	$AnimatedSprite.play("Idle")

func _physics_process(delta):
	if dead:
		return
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	if Input.is_action_pressed("p2_right"):
		velocity.x += ACCELERATION
		keep_direction.x = 1
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("Walk")
	elif Input.is_action_pressed("p2_left"):
		velocity.x -= ACCELERATION
		keep_direction.x = -1
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("Walk")
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
		$AnimatedSprite.play("Idle")
	
	handle_jump()
	
	velocity = move_and_slide(velocity, UP)

func handle_jump():
	if Input.is_action_pressed("p2_action"):
		if velocity.y >= 0:
			velocity.y += GRAVITY * FALL_MULTIPLIER
		else:
			velocity.y += GRAVITY
		if is_on_floor():
			velocity.y = -JUMP_FORCE
	else:
		velocity.y += GRAVITY * LOW_JUMP_MULTIPLIER
	if not is_on_floor():
		$AnimatedSprite.stop()
		$AnimatedSprite.set_animation("Jump")
		var frame
		if velocity.y >= 0:
			if velocity.y <= RISING_MIDDLE_JUMP_THRESHHOLD:
				frame = 1
			else:
				frame = 0
		else:
			if velocity.y >= FALLING_MIDDLE_JUMP_THRESHHOLD:
				frame = 1
			else:
				frame = 2
		$AnimatedSprite.set_frame(frame)

func death():
	velocity = Vector2.ZERO
	dead = true
	$AnimatedSprite.modulate = Color(255, 255, 255, 1)
	# play death animation
	$TouchPlayer.queue_free()
	$DyingEffect.emitting = true
	$DyingTimer2.start(0.1)
	$DyingTimer.start(1)

func disappear():
	$AnimatedSprite.hide()

func free():
	queue_free()

func _on_TouchPlayer_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.is_in_group("damage"):
		death()

func _on_TouchPlayer_body_entered(body):
	if body.is_in_group("damage"):
		death()
