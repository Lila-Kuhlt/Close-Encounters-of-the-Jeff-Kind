extends CharacterBody2D
const bullet_scene = preload("res://scenes/bullets/Line.Bullet.tscn")
var bullet

var x = 0
var angle = 0

func _on_timer_timeout():
	bullet = bullet_scene.instantiate()
	bullet.direction = Vector2(sin(x), cos(x))
	angle = atan2(bullet.direction.y, bullet.direction.x) - PI/2
	bullet.rotate(angle)
	bullet.position = position
	x += 0.5
	get_parent().add_child(bullet)
