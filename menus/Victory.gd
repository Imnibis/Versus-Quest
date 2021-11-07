extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Restart.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Restart_pressed():
	get_tree().change_scene("res://scenes/level0/level0.tscn")

func _on_Quit_pressed():
	get_tree().quit()
