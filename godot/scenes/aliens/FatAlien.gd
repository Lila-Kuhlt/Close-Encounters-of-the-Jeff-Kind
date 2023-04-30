extends CharacterBody2D

@export var MOVEMENT_SPEED = 15
@export var MIN_MOVEMENT_RADIUS := 3
@export var MAX_MOVEMENT_RADIUS := 8
@export var WALK_CHANCE := 0.2
const Bullet = preload("res://scenes/bullets/PointBullet.tscn")
var x := 0.0

@onready var _astar: AStarGrid2D = get_parent()._astar
@onready var _walkables: Array[Vector2i] = get_parent().walkable_street_tiles
@onready var target_path: PackedVector2Array = PackedVector2Array([])

func _physics_process(_delta):
	if target_path.size() < 1:
		return
	var old_dist := target_path[0] - position
	velocity = old_dist.normalized() * MOVEMENT_SPEED
	move_and_slide()
	var distlen := (target_path[0] - position).length()
	if distlen < 0.01 or distlen >= old_dist.length():
		target_path = target_path.slice(1)

func _on_timer_timeout():
	var bullet = Bullet.instantiate()
	bullet.direction = Vector2.from_angle(x)
	bullet.rotate(atan2(bullet.direction.y, bullet.direction.x) - PI/2)
	bullet.position = position
	x += 0.5
	get_parent().add_child(bullet)

func _on_walk_timer_timeout() -> void:
	if randf_range(0, 1) > WALK_CHANCE:
		return
	var tile_id := _walkables[randi_range(0, len(_walkables) - 1)]
	var src: Vector2i = (position / _astar.cell_size).floor()
	var dst: Vector2i = tile_id
	target_path = _astar.get_point_path(src, dst)
