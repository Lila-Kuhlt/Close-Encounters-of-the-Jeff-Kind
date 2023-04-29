extends CharacterBody2D

@export var MOVEMENT_SPEED = 15
const Bullet = preload("res://scenes/bullets/Point.Bullet.tscn")
var x := 0.0

@onready var _astar: AStarGrid2D = get_parent()._astar
@onready var target_path = _astar.get_point_path(get_parent().vector_to_grid(position), Vector2i(28, 18))


func _physics_process(_delta):
	if target_path.size() > 1:
		var direction = target_path[1] - position
		velocity = ((direction) / _astar.cell_size).ceil() * MOVEMENT_SPEED
		print("direction: ", direction)
		print("target: ", target_path)
		move_and_slide()
		if (direction.abs() <= Vector2(1, 1)):
			target_path = target_path.slice(1)

func _on_timer_timeout():
	var bullet = Bullet.instantiate()
	bullet.direction = Vector2(sin(x), cos(x))
	bullet.rotate(atan2(bullet.direction.y, bullet.direction.x) - PI/2)
	bullet.position = position
	x += 0.5
	print("FatAlien.get_parent(): ", get_parent())
	get_parent().add_child(bullet)
