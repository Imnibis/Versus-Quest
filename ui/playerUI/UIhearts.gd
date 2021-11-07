extends Control

export (int) var currentLife = 3

func _ready():
	if (currentLife == 2):
		$FullHearts.rect_size.x -= 16
	elif (currentLife == 1):
		$FullHearts.rect_size.x -= 32
	elif (currentLife == 0):
		$FullHearts.rect_size.x -= 48
