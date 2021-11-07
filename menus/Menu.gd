extends Control

func _ready():
	var font = DynamicFont.new()
	font.font_data = load("res://menus/dogicapixel.ttf")
	$VBoxContainer/StartButton.set("custom_fonts/font", font)
	$VBoxContainer/OptionButton.set("custom_fonts/font", font)
	$VBoxContainer/ExitButton.set("custom_fonts/font", font)
	$VBoxContainer/StartButton.grab_focus()

func _on_StartButton_pressed():
	TransitionsAl.new_scene_dir = "res://scenes/level0/level0.tscn"
	TransitionsAl.load_state()
	
func _on_OptionButton_pressed():
	pass # Replace with function body.

func _on_ExitButton_pressed():
	get_tree().quit()
