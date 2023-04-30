extends CharacterBody2D

const Bullet = preload("res://scenes/bullets/LineBullet.tscn")

var x := 0.0

func _on_timer_timeout():
	var bullet = Bullet.instantiate()
	var bullet2 = Bullet.instantiate()
	bullet.direction = Vector2.from_angle(x)
	bullet2.direction = -Vector2.from_angle(x)
	bullet.rotation = x - PI/2
	bullet2.rotation = x - PI/2
	bullet.position = position
	bullet2.position = position
	x += PI/2
	get_parent().add_child(bullet)
	get_parent().add_child(bullet2)
