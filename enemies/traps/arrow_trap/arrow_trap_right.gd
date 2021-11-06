extends Node2D

export (PackedScene) var Arrow
export (String, "LEFT", "RIGHT") var direction

func _ready():
	if (direction == "LEFT"):
		$Arrow_trap_sprite.rotation_degrees = 180

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		shoot()	

func shoot():
	var arrow = Arrow.instance()
	match direction:
		"LEFT":
			arrow.rotation_degrees = fmod(rotation_degrees, 180)
			arrow.speed = 500
		"RIGHT":
			arrow.speed = -500
	add_child(arrow)


