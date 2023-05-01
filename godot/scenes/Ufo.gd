extends Node2D

const MARGIN := Vector2(10, 10)
const SPEED: float = 200
const BULLET_SPEED: float = 1
const MAX_TRAVEL_TIME := 1000

const Bullet = preload("res://scenes/bullets/PointBullet.tscn")

var direction: Vector2
var travel_time := 0

func _ready():
	var viewport := get_viewport()
	var vps := viewport.get_visible_rect().size
	var cam := viewport.get_camera_2d()
	var vp: Rect2 = Rect2(cam.position - vps * 0.5, vps)
	var center := vp.get_center()
	position = rand_edge_point(vp) + vp.position
	direction = position.direction_to(center)

func _physics_process(delta):
	var region: Rect2 = $Sprite2D.get_rect()
	region.position += position
	if Globals.WORLD_BOUNDARY.intersects(region):
		position += delta * SPEED * direction
		travel_time += delta * SPEED
		if travel_time > MAX_TRAVEL_TIME:
			queue_free()
	else:
		queue_free()

func rand_edge_point(vp: Rect2) -> Vector2:
	var edge: int = randi_range(0,3)
	var rand := randf_range(0,1)
	var coord := rand * vp.size

	if edge == 0:
		coord.x = -MARGIN.x
	elif edge == 1:
		coord.x = vp.size.x + MARGIN.x
	elif edge == 2:
		coord.y = -MARGIN.y
	elif edge == 3:
		coord.y = vp.size.y + MARGIN.y

	return coord

func _on_timer_timeout():
	for alpha in [1, -1]:
		var bullet = Bullet.instantiate()

		bullet.direction = direction.rotated(alpha) * BULLET_SPEED
		bullet.position = position

		get_parent().add_child(bullet)



