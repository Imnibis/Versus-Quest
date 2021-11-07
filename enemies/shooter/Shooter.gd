extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var projectile_object
export (String, "LEFT", "RIGHT") var direction = "RIGHT"
export (float) var projectile_offset = 10
export (float) var projectile_speed = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShootAnimationTimer.connect("timeout", self, "end_shoot_animation")
	$AnimatedSprite.play("Idle")

func _input(event):
	if event.is_action_pressed("p2_right"):
		direction = "RIGHT"
	elif event.is_action_pressed("p2_left"):
		direction = "LEFT"
	if event.is_action_pressed("p2_action"):
		$AnimatedSprite.play("Shoot")
		$ShootAnimationTimer.start()
		spawn_projectile()

func end_shoot_animation():
	$AnimatedSprite.play("Idle")

func spawn_projectile():
	var projectile = projectile_object.instance()
	projectile.shooter = self
	projectile.direction = direction
	projectile.speed = projectile_speed
	add_child(projectile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite.flip_h = direction == "RIGHT"
