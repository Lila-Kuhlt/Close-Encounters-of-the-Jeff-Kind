extends CharacterBody2D
const bullet_scene = preload("res://scenes/bullets/Line.Bullet.tscn")
var bullet
var bullet2

var x = 0
var angle = 0

func _on_timer_timeout():
	bullet = bullet_scene.instantiate()
	bullet2 = bullet_scene.instantiate()
	bullet.direction = Vector2(sin(x), cos(x))
	bullet2.direction = Vector2(-sin(x), -cos(x))
	bullet.rotate(atan2(bullet.direction.y, bullet.direction.x) - PI/2)
	bullet2.rotate(atan2(bullet.direction.y, bullet.direction.x) - PI/2)
	bullet.position = position
	bullet2.position = position
	x += PI/2
	get_parent().add_child(bullet)
	get_parent().add_child(bullet2)
