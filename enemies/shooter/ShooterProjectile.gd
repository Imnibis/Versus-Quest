extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = "RIGHT"
var shooter
var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body

func _physics_process(delta):
	position.x += (speed * delta) * (-1 if direction == "LEFT" else 1)
	$Sprite.flip_h = (direction == "RIGHT")
	$LeftCollision.disabled = (direction == "RIGHT")
	$RightCollision.disabled = (direction == "LEFT")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
