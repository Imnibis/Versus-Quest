extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = "RIGHT"
var shooter
var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_ShooterProjectile_body_entered")
	$Timeout.connect("timeout", self, "timeout")

func _physics_process(delta):
	position.x += (speed * delta) * (-1 if direction == "LEFT" else 1)
	$AnimatedSprite.flip_h = (direction == "RIGHT")
	$LeftCollision.disabled = (direction == "RIGHT")
	$RightCollision.disabled = (direction == "LEFT")

func _on_ShooterProjectile_body_entered(body):
	if body.is_in_group("playable") and body != shooter:
		queue_free()

func timeout():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
