extends CharacterBody2D

@export var MOVEMENT_SPEED = 15
@export var MIN_MOVEMENT_RADIUS := 3
@export var MAX_MOVEMENT_RADIUS := 8
@export var WALK_CHANCE := 0.2

# const Bullet = preload("res://scenes/bullets/PointBullet.tscn")
var Bullet

@onready var _astar: AStarGrid2D = get_parent()._astar
@onready var _walkables: Array[Vector2i] = get_parent().walkable_street_tiles
@onready var target_path: PackedVector2Array = PackedVector2Array([])

@onready var anim_player: AnimationPlayer = get_node('WalkAnimationPlayer') if has_node('WalkAnimationPlayer') else null

func _physics_process(_delta):
	if target_path.size() < 1:
		if anim_player:
			anim_player.play('idle')
		return
	var old_dist := target_path[0] - position
	velocity = old_dist.normalized() * MOVEMENT_SPEED
	if not move_and_slide() and anim_player:
		anim_player.play('walk')
	elif anim_player:
		anim_player.play('idle')
	var distlen := (target_path[0] - position).length()
	if distlen < 0.01 or distlen >= old_dist.length():
		target_path = target_path.slice(1)

func spawn_bullet(rot_angle: float) -> void:
	var bullet = Bullet.instantiate()
	bullet.direction = Vector2.from_angle(rot_angle)
	bullet.rotation = rot_angle - PI/2
	bullet.position = position
	get_parent().add_child(bullet)

func _on_walk_timer_timeout() -> void:
	if randf_range(0, 1) > WALK_CHANCE:
		return
	var tile_id := _walkables[randi_range(0, len(_walkables) - 1)]
	var src: Vector2i = (position / _astar.cell_size).floor()
	var dst: Vector2i = tile_id
	target_path = _astar.get_point_path(src, dst)
