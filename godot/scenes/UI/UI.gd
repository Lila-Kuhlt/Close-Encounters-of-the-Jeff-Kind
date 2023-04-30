extends CanvasLayer

var just_paused := false

func _ready():
	add_to_group("UI")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('pause'):
		if not just_paused:
			get_tree().paused = true
			$PauseMenu.show()
	else:
		just_paused = false

func _on_button_pressed() -> void:
	just_paused = true
	get_tree().paused = false
	$PauseMenu.hide()

func trigger_game_over() -> void:
	get_tree().paused = true
	$GameOver.show()
