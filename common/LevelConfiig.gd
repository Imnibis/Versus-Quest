extends Node2D

var levelIfWin : String
var levelIfLose : String

func _ready():
	var nodeName = self.name
	match nodeName:
		"Level-3":
			levelIfWin = "res://scenes/level -2/level-2.tscn"
			levelIfLose = "res://scenes/level0/level0.tscn"
		"Level-2":
			levelIfWin = "res://scenes/level -1/level-1.tscn"
			levelIfLose = "res://scenes/level -3/level-3.tscn" 
		"Level-1":
			levelIfWin = "res://scenes/level0/level0.tscn"
			levelIfLose = "res://scenes/level -2/level-2.tscn"
		"Level0":
			levelIfWin = "res://scenes/level1/level1.tscn"
			levelIfLose = "res://scenes/level -1/level-1.tscn"
		"Level1":
			levelIfWin = "res://scenes/level2/level2.tscn"
			levelIfLose = "res://scenes/level0/level0.tscn"
		"Level2":
			levelIfWin = "res://scenes/level3/level3.tscn"
			levelIfLose = "res://scenes/level1/level1.tscn"
		"Level3":
			levelIfWin = "res://scenes/level0/level0.tscn"
			levelIfLose = "res://scenes/level2/level2.tscn"
	$Player.connect("win", self, "player_won")
	$Player.connect("dead", self, "player_dead")
	print(levelIfWin)
	print(levelIfLose)
	
func player_won():
	get_tree().change_scene(levelIfWin)

func player_dead():
	get_tree().change_scene(levelIfLose)
