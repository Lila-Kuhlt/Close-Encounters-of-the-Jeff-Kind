extends "res://scenes/bullets/Bullet.gd"

const SPEED_INCREASE := 0.4
const ANGLE := 0.03

func _physics_process(delta):
	direction = direction.rotated(ANGLE)
	speed += SPEED_INCREASE
	super._physics_process(delta)
