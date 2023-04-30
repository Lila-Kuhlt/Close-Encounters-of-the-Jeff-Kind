extends "res://scenes/bullets/Bullet.gd"

const HOMING_FACTOR := 0.01

func _ready() -> void:
	$AnimationPlayer.play('rocket_fly')

func _physics_process(delta):
	var player_direction = position.direction_to(get_parent().get_node("Jeff").position)
	direction = lerp(direction, player_direction, HOMING_FACTOR)
	rotation = direction.angle() + PI * 0.5
	super._physics_process(delta)
