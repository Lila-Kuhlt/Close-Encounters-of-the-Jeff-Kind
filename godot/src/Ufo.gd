extends Node2D

const MARGIN := Vector2(10, 10)
const SPEED: float = 0.25

const Bullet = preload("res://scenes/bullets/Point.Bullet.tscn")

var t: float
var start: Vector2
var dest: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var center := get_viewport_rect().size
	center.x = center.x / 2
	center.y = center.y / 2
	start = rand_edge_point()
	dest = mirror_point(start, center)

	var viewport_pos := get_viewport_rect().position
	start += viewport_pos
	dest += viewport_pos

	position = start
	t = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta * SPEED
	position = lerp(start, dest, t)

	if t >= 1:
		queue_free()

func rand_edge_point() -> Vector2:
	var edge: int = randi_range(0,3)
	var viewport_size := get_viewport_rect().size
	var rand := randf_range(0,1)
	var coord := rand * viewport_size

	if edge == 0:
		coord.x = -MARGIN.x
	elif edge == 1:
		coord.x = viewport_size.x + MARGIN.x
	elif edge == 2:
		coord.y = -MARGIN.y
	elif edge == 3:
		coord.y = viewport_size.y + MARGIN.y

	return coord

func mirror_point(point: Vector2, center: Vector2) -> Vector2:
	return 2 * center - point

func _on_timer_timeout():
	var bullet = Bullet.instantiate()

	bullet.direction = Vector2(dest.x - start.x, dest.y - start.y) * 0.005
	var r := randf_range(-1, 1)
	bullet.direction = bullet.direction.rotated(r * 0.05)
	bullet.position = position
	bullet.transform = bullet.transform.scaled_local(Vector2(0.25, 0.25))

	get_parent().add_child(bullet)



