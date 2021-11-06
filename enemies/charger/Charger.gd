extends KinematicBody2D

const UP : Vector2 = Vector2(0, -1)

export (PackedScene) var dash_object
export var max_speed = 1.0
export var acceleration = 1.0
export var max_fall_speed = 1.0
export var gravity = 1.0
export var dash_duration = 1.0
export var dash_distance = 1.0
export var dash_animation_smoothing = 1.0
export var dash_ghost_frequency = 0.5
export var dash_cooldown = 2.0

var direction = 1
var dashing = false
var can_dash = true
var time = 0
var last_ghost = 0
var velocity = Vector2(0, 0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("Idle")
	$DashCooldown.connect("timeout", self, "reset_dash")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("p2_action") and can_dash:
		dash()

func _physics_process(delta):
	time += delta
	if not dashing:
		var movement_x = Input.get_action_strength("p2_right") - Input.get_action_strength("p2_left")
		direction = -1 if movement_x < 0 else (1 if movement_x > 0 else direction)
		$AnimatedSprite.flip_h = direction == 1
		if movement_x != 0:
			velocity.x += movement_x * acceleration
			$AnimatedSprite.play("Walk")
		else:
			velocity.x *= 0.2
			$AnimatedSprite.play("Idle")
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		if not is_on_floor():
			velocity.y += gravity
			velocity.y = min(velocity.y, max_fall_speed)
		else:
			velocity.y = max(0, velocity.y)
		move_and_slide(velocity, UP)

func dash():
	time = 0
	last_ghost = 0
	dashing = true
	can_dash = false
	$AnimatedSprite.play("Dash")
	var original_position = position
	var end_position = original_position + Vector2(dash_distance * direction, 0)
	while time < dash_duration:
		if time >= last_ghost + dash_ghost_frequency:
			spawn_ghost()
			last_ghost = time
		move_and_slide(original_position.cubic_interpolate(end_position, original_position + Vector2(dash_animation_smoothing, 0),  end_position + Vector2(dash_animation_smoothing, 0), time / dash_duration) - position)
		yield(get_tree(), "idle_frame")
	move_and_slide(end_position - position)
	$DashCooldown.start(dash_cooldown)
	dashing = false

func spawn_ghost():
	var dash_node = dash_object.instance()
	dash_node.texture = $AnimatedSprite.frames.get_frame($AnimatedSprite.animation, $AnimatedSprite.frame)
	dash_node.global_position = $AnimatedSprite.global_position
	dash_node.global_scale = $AnimatedSprite.global_scale
	dash_node.flip_h = $AnimatedSprite.flip_h
	get_parent().add_child(dash_node)

func reset_dash():
	can_dash = true
