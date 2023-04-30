extends "res://scenes/aliens/Alien.gd"

func _ready() -> void:
	Bullet = preload("res://scenes/bullets/HomingBullet.tscn")

func _on_timer_timeout():
	spawn_bullet(randf_range(0, 2.0 * PI))
