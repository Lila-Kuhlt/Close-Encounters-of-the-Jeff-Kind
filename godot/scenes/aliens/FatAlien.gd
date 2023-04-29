extends CharacterBody2D

const Bullet = preload("res://scenes/bullets/Point.Bullet.tscn")

var x := 0.0

func _on_timer_timeout():
	var bullet = Bullet.instantiate()
	bullet.direction = Vector2(sin(x), cos(x))
	bullet.rotate(atan2(bullet.direction.y, bullet.direction.x) - PI/2)
	bullet.position = position
	x += 0.5
	print("FatAlien.get_parent(): ", get_parent())
	get_parent().add_child(bullet)
