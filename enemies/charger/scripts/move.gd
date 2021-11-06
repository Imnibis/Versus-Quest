extends KinematicBody2D

export var speed := 1
export var dash_duration = 1
export var dash_distance = 1

var direction = 1
var dashing = false
var time = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("p2_action"):
		dash()

func _physics_process(delta):
	time += delta
	if not dashing:
		var movement_x = Input.get_action_strength("p2_right") - Input.get_action_strength("p2_left")
		direction = -1 if movement_x < 0 else (1 if movement_x > 0 else direction)
		move_and_slide(Vector2(movement_x * speed * delta, 0));

func dash():
	time = 0
	dashing = true
	var original_position = position
	var end_position = original_position + Vector2(dash_distance * direction, 0)
	while time < dash_duration:
		move_and_slide(original_position.cubic_interpolate(end_position) - position)
		yield(get_tree(), "idle_frame")
	move_and_slide(end_position - position)
	dashing = false
