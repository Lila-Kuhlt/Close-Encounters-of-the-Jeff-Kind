extends CharacterBody2D
const bullet_scene = preload("res://scenes/Bullet.tscn")
var bullet

var x = 0

func _on_timer_timeout():
	bullet = bullet_scene.instantiate()
	bullet.direction = Vector2(sin(x), cos(x))
	bullet.position = position
	x += 0.5
	get_parent().add_child(bullet)
