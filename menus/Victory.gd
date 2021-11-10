extends Node


func _ready():
	$VBoxContainer/Restart.grab_focus()

func _on_Restart_pressed():
	get_tree().change_scene("res://scenes/level0/level0.tscn")

func _on_Quit_pressed():
	get_tree().quit()
