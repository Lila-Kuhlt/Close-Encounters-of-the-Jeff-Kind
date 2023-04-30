extends "res://scenes/bullets/Bullet.gd"

const HOMING_FACTOR := 0.01
const PERCEPTION_RADIUS := 120

func _ready() -> void:
	$AnimationPlayer.play('rocket_fly')

func _physics_process(delta):
	var player_direction = get_parent().get_node("Jeff").position - position
	var distance: float = player_direction.length()
	if distance <= PERCEPTION_RADIUS:
		player_direction /= distance
		direction = lerp(direction, player_direction, HOMING_FACTOR)
	rotation = direction.angle() + PI * 0.5
	super._physics_process(delta)
