extends Control

export var time : int = 3

var finish : bool = false

signal count_finish

func _ready():
	$Decrease.connect("timeout", self, "change_value")
	$Decrease.start(1)
	pass

func _physics_process(delta):
	if finish:
		emit_signal("count_finish")
		queue_free()
	
func change_value():
	time -= 1
	
	if time == 0:
		finish = true
		return
	$Timer.bbcode_text = "[center]" + String(time) + "[/center]"
	$Decrease.start(1)
	pass
