extends CanvasLayer

func _ready():
	if Globals.DEBUG:
		_on_start_button_pressed()
	$Panel/CenterContainer/VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_quit_button_pressed():
	Globals.quit_game()
