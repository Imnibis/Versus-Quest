extends Area2D

onready var arrow_traps = get_tree().get_nodes_in_group("arrow")

func _ready():
	connect("body_entered", self, "on_Body_entered")
	$Timer.connect("timeout", self, "on_Timeout")
	
func on_Body_entered(body):
	if (body.is_in_group("playable")):
		if ($Timer.time_left == 0):
			for nodes in arrow_traps:
				nodes.shoot()
				$sprite_left.visible = false
				$sprite_right.visible = true
				$Timer.start()
		
func on_Timeout():
	$sprite_right.visible = false
	$sprite_left.visible = true
