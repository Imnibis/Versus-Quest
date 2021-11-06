extends Area2D

var speed = 0
enum DIRECTION{
	LEFT = -500
	RIGHT = 500
}

func _ready():
	connect("body_entered", self, "_on_Arrow_body_entered")

func _physics_process(delta):
	position += transform.x * speed * delta

func setSpeed(value):
	speed = value

func _on_Arrow_body_entered(body):
	if body.is_in_group("playable"):
		print("u ded")
	queue_free()
