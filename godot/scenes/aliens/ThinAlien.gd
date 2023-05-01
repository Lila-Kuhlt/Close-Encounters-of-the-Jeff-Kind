extends CharacterBody2D

@export var NUM_BULLETS := 6

const Bullet = preload("res://scenes/bullets/CircleBullet.tscn")

var shooting_angle := 0

func _on_timer_timeout():
	var local_angle := shooting_angle
	var angle_step := 2.0 * PI / float(NUM_BULLETS)
	for i in range(NUM_BULLETS):
		var bullet = Bullet.instantiate()
		bullet.direction = Vector2.from_angle(local_angle)
		bullet.rotation = local_angle - PI/2
		bullet.position = position
		get_parent().add_child(bullet)
		local_angle += angle_step
	shooting_angle = fposmod(shooting_angle + 0.5, 2.0 * PI)
