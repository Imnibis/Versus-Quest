extends Node2D

export (PackedScene) var Arrow
export (String, "LEFT", "RIGHT") var direction

	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		shoot()	

func shoot():
	var arrow = Arrow.instance()
	match direction:
		0:
			arrow.rotation = 180
			arrow.speed = arrow.direction.RIGHT
		1:
			arrow.speed = arrow.direction.LEFT
	add_child(arrow)

