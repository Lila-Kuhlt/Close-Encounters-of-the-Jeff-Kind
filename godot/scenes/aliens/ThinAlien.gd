extends CharacterBody2D

@export var NUM_BULLETS := 6

const Bullet = preload("res://scenes/bullets/CircleBullet.tscn")

var shooting_direction := Vector2(1, 0)

func _on_timer_timeout():
	for i in range(NUM_BULLETS):
		var bullet = Bullet.instantiate()
		bullet.direction = shooting_direction.rotated(i * (2 * PI / NUM_BULLETS))
		bullet.rotation = bullet.direction.angle() - PI/2
		bullet.position = position
		get_parent().add_child(bullet)
	shooting_direction = shooting_direction.rotated(0.5)
