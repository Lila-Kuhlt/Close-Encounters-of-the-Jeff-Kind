extends CharacterBody2D

@export var MOVEMENT_SPEED = 15
@export var MIN_MOVEMENT_RADIUS := 3
@export var MAX_MOVEMENT_RADIUS := 8
@export var WALK_CHANCE := 0.2
@export var NUM_BULLETS := 6
const Bullet = preload("res://scenes/bullets/CircleBullet.tscn")
var x := 0.0

func _on_timer_timeout():
	for i in range(NUM_BULLETS):
		var bullet = Bullet.instantiate()
		bullet.direction = Vector2.from_angle(x + i * (PI / (NUM_BULLETS / 2)))
		bullet.rotation = x - PI/2
		bullet.position = position
		get_parent().add_child(bullet)
	x += 0.5
