extends Node2D

func _ready():
	$Detection.connect("body_entered", self, "on_body_entered")
	$Timer.connect("timeout", self, "on_timeout")

func on_body_entered(body):
	if (body.is_in_group("playable")):
		$Timer.start()

func on_timeout():
	$AnimationPlayer.play("default")
