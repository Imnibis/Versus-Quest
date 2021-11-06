extends KinematicBody2D

export var speed := 1.0
export var dash_duration = 1.0
export var dash_distance = 1.0
export var dash_animation_smoothing = 1.0
export var dash_cooldown = 2.0

var direction = 1
var dashing = false
var can_dash = true
var time = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
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
		move_and_slide(Vector2(movement_x * speed * delta, ProjectSettings.get_setting("physics/2d/default_gravity")));

func dash():
	time = 0
	dashing = true
	can_dash = false
	var original_position = position
	var end_position = original_position + Vector2(dash_distance * direction, 0)
	while time < dash_duration:
		move_and_slide(original_position.cubic_interpolate(end_position, original_position + Vector2(dash_animation_smoothing, 0),  end_position + Vector2(dash_animation_smoothing, 0), time / dash_duration) - position)
		yield(get_tree(), "idle_frame")
	move_and_slide(end_position - position)
	$DashCooldown.start(dash_cooldown)
	dashing = false

func reset_dash():
	can_dash = true
