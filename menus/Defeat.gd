extends Node


func _ready():
	$VBoxContainer/Restart.grab_focus()
	$ParticlesArea.connect("area_entered", self, "_on_Sprite_entered")
	$PositionInterpolate.interpolate_property($ChildIdle, "position", $ChildIdle.position, Vector2($ChildIdle.position.x, $ChildIdle.position.y + 500), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$PositionInterpolate.start()
	$AngleInterpolate.interpolate_property($ChildIdle, "rotation_degrees", $ChildIdle.rotation_degrees, $ChildIdle.rotation_degrees + 2000, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$AngleInterpolate.start()


func _on_Restart_pressed():
	get_tree().change_scene("res://scenes/level0/level0.tscn")

func _on_Quit_pressed():
	get_tree().quit()
	
func _on_Sprite_entered(area):
	$PloofParticles.emitting = true
