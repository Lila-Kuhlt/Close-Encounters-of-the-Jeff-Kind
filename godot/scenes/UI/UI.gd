extends CanvasLayer

const Heart = preload("res://scenes/UI/Heart.tscn")

var just_paused := false
var hearts: Array[TextureRect] = []

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

func trigger_game_over(score: int) -> void:
	get_tree().paused = true
	var game_over_label = $GameOver/Panel/MarginContainer/VBoxContainer/Label
	game_over_label.text = game_over_label.text.format({"score": score})
	$GameOver.show()

func set_max_health(health: int) -> void:
	for i in range(health):
		var heart: TextureRect = Heart.instantiate()
		$VBox/HeartContainer.add_child(heart)
		hearts.append(heart)
	set_health(health)

func set_health(health: int) -> void:
	var i := 0
	for child in hearts:
		var tex: AtlasTexture = child.texture
		tex.region.position.x = 8 if i < health else 0
		i += 1

func set_score(score: int) -> void:
	$VBox/Label.text = "Score: {0}".format([score])

func _on_quit_button_pressed() -> void:
	Globals.quit_game()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	get_tree().paused = false
