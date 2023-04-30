extends "res://scenes/bullets/Bullet.gd"

var x = 0.03

func _physics_process(delta):
	direction = direction.rotated(x)
	SPEED += 0.4
	# x -= 0.01
	super._physics_process(delta)
