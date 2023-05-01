extends CharacterBody2D

const Bullet = preload("res://scenes/bullets/LineBullet.tscn")

var shooting_direction := Vector2(1, 0)

func _on_timer_timeout():
	var bullet = Bullet.instantiate()
	var bullet2 = Bullet.instantiate()
	bullet.direction = shooting_direction
	bullet2.direction = -shooting_direction
	bullet.rotation = bullet.direction.angle() - PI/2
	bullet2.rotation = bullet2.direction.angle() - PI/2
	bullet.position = position
	bullet2.position = position
	shooting_direction = shooting_direction.rotated(PI/2)
	get_parent().add_child(bullet)
	get_parent().add_child(bullet2)
