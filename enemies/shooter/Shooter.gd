extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var projectile_object
export (String, "LEFT", "RIGHT") var direction = "RIGHT"
export (float) var projectile_offset = 1
export (float) var projectile_speed = 50
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$DyingTimer.connect("timeout", self, "free")
	$DyingTimer2.connect("timeout", self, "disappear")
	$ShootAnimationTimer.connect("timeout", self, "end_shoot_animation")
	$AnimatedSprite.play("Idle")

func _input(event):
	if dead:
		return
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
	projectile.position = (projectile.position +
		Vector2(-projectile_offset if direction == "LEFT" else projectile_offset, 0))
	projectile.speed = projectile_speed
	add_child(projectile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite.flip_h = direction == "RIGHT"

func death():
	dead = true
	$AnimatedSprite.modulate = Color(255, 255, 255, 1)
	# play death animation
	$TouchPlayer.queue_free()
	$DyingEffect.emitting = true
	$DyingTimer2.start(0.1)
	$DyingTimer.start(1)

func disappear():
	$AnimatedSprite.hide()

func free():
	queue_free()

func _on_TouchPlayer_area_shape_entered(area_id, area, area_shape, local_shape):
	if area.is_in_group("damage"):
		death()

func _on_TouchPlayer_body_entered(body):
	if body.is_in_group("damage"):
		death()
