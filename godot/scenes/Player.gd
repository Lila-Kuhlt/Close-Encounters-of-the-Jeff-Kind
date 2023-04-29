extends CharacterBody2D

const SPEED = 300.0
const PROMILLE = 0.04
const PROMILLE2 = 0.2

var uwu = Vector2(0, 0)
var uwu2 = Vector2(0, 0)
var rng = RandomNumberGenerator.new()

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	direction += uwu
	velocity = direction * SPEED
	if not move_and_slide():
		rotate(direction.length())
		uwu += Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * PROMILLE * direction.length()
		uwu2 += Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)) * PROMILLE2 * direction.length()
		scale = Vector2(1, 1) + uwu2

	var screen_size = get_viewport_rect().size
	position.x = fposmod(position.x, screen_size.x)
	position.y = fposmod(position.y, screen_size.y)
