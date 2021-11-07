extends Node2D

func _ready():
	$CountDown.connect("count_finish", self, "finish")
	get_tree().paused = true
	pass

func finish():
	get_tree().paused = false
