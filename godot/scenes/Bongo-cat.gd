extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var uwu = Vector2(0, 0)
var uwu2 = Vector2(0, 0)
var rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	uwu += Vector2(rng.randf_range(-0.2, 1), rng.randf_range(-0.2, 1)) * 0.1
	uwu2 += Vector2(rng.randf_range(-0.2, 1), rng.randf_range(-0.2, 1)) * uwu * 0.1
	var uwu3 = Vector2(sin(uwu.x), cos(uwu.y))
	scale = uwu3
