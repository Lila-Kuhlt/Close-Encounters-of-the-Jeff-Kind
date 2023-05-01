extends CanvasLayer

const Heart = preload("res://scenes/UI/Heart.tscn")

var just_paused := false
var hearts: Array[TextureRect] = []
var in_tutorial := true

var tutorial_page := 0
@onready var tutorial_page_count: int = $Tutorial/PanelContainer/MarginContainer/VBoxContainer/Pages.get_child_count()

func _ready() -> void:
	get_tree().paused = true
	in_tutorial = true
	go_to_tutorial_page(0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('pause') and not in_tutorial:
		if not just_paused:
			get_tree().paused = true
			$PauseMenu.show()
			$PauseMenu/Panel/MarginContainer/VBoxContainer/ResumeButton.grab_focus()
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
	$GameOver/Panel/MarginContainer/VBoxContainer/RestartButton.grab_focus()

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

func _on_tutorial_close_button_pressed() -> void:
	in_tutorial = false
	get_tree().paused = false
	$Tutorial.hide()

func go_to_tutorial_page(n) -> void:
	tutorial_page = n
	var pages: Control = $Tutorial/PanelContainer/MarginContainer/VBoxContainer/Pages
	var name: String = "Page%d" % n
	for _node in pages.get_children():
		var node: Node = _node
		if node.name == name:
			node.show()
		else:
			node.hide()
	var next_button = $Tutorial/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextButton
	var close_button = $Tutorial/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CloseButton
	if n >= tutorial_page_count - 1:
		next_button.hide()
		close_button.grab_focus()
	else:
		next_button.show()
		next_button.grab_focus()

func _on_tutorial_next_button_pressed() -> void:
	go_to_tutorial_page(tutorial_page + 1)
