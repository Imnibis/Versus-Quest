extends Area2D

var speed = 0

func _ready():
	connect("area_entered", self, "on_Arrow_area_entered")
	$Timer.connect("timeout", self, "on_Timeout")
	
func _physics_process(delta):
	position += transform.x * speed * delta

func setSpeed(value):
	speed = value

func on_Arrow_area_entered(area):
	if area.is_in_group("playable"):
		queue_free()
	queue_free()
		
func on_Timeout():
	queue_free()
