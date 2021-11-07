extends Area2D

var speed = 0

func _ready():
	connect("body_entered", self, "on_Arrow_body_entered")
	$Timer.connect("timeout", self, "on_Timeout")
	
func _physics_process(delta):
	position += transform.x * speed * delta

func setSpeed(value):
	speed = value

func on_Arrow_body_entered(body):
	if body.is_in_group("playable"):
		queue_free()
		
func on_Timeout():
	queue_free()
