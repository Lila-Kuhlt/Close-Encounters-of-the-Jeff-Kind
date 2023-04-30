extends "res://scenes/bullets/Bullet.gd"

const HOMING_FACTOR := 0.01

func _physics_process(delta):
	var player_direction = position.direction_to(get_parent().get_node("Jeff").position)
	direction = lerp(direction, player_direction, HOMING_FACTOR)
	super._physics_process(delta)
