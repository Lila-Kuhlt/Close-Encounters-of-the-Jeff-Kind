extends CharacterBody2D

@export var SPEED := 30.0

var direction: Vector2

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()

func _on_player_hit(body):
	# hit player and despawn
	body.hit_player(direction)
	queue_free()

func _on_building_collision(body):
	# despawn
	queue_free()
