extends Control

func changeHearts(currentLife : int):
	if (currentLife == 2):
		$FullHearts.rect_position.x += 11
		$FullHearts.rect_size.x -= 16
	elif (currentLife == 1):
		$FullHearts.rect_position.x += 22		
		$FullHearts.rect_size.x -= 32
	elif (currentLife <= 0):
		$FullHearts.rect_position.x += 33		
		$FullHearts.rect_size.x -= 48
