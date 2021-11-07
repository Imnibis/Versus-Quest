extends Control

export var time : int = 3

var finish : bool = false

func _ready():
	#var font = DynamicFont.new()
	#font.font_data = load("res://ui/common/Retro Gaming.ttf")
	#$VBoxContainer/StartButton.set("custom_fonts/font", font)
	#$Decrease.connect("timeout", self, "change_value")
	#$Decrease.start(time)
	pass

func _physics_process(delta):
	pass
	
func change_value():
	time -= 1
	
	if time == 0:
		finish = true
		return
	
	$Decrease.start(time)
	pass
