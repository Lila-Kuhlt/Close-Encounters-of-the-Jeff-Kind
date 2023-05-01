extends "res://scenes/aliens/Alien.gd"

var rot_angle := 0.0

func _ready() -> void:
	Bullet = preload("res://scenes/bullets/PointBullet.tscn")

func _on_timer_timeout():
	spawn_bullet(rot_angle)
	spawn_bullet(rot_angle + PI/2)
	spawn_bullet(rot_angle + PI)
	spawn_bullet(rot_angle + 3 * PI/2)
	rot_angle += 0.5
