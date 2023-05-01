extends CanvasLayer

func _ready():
	if Globals.DEBUG:
		_on_start_button_pressed()
	get_window().content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	$Panel/CenterContainer/VBoxContainer/StartButton.grab_focus()
	$AnimationPlayer.play('title_rotate')

func _on_start_button_pressed():
	get_window().content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	get_tree().change_scene_to_file("res://scenes/World.tscn")

func _on_quit_button_pressed():
	Globals.quit_game()
