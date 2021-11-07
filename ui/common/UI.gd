extends CanvasLayer

export (int) var playerHearts
export (int) var enemiesHearts

func _ready():
	$PlayerUI.changeHearts(playerHearts)
	$EnemyUI.changeHearts(enemiesHearts)
