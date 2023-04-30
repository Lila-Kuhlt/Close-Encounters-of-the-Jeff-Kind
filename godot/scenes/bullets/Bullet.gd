extends CharacterBody2D

@export var speed := 30.0

var direction: Vector2

func _physics_process(_delta: float) -> void:
	var region: Rect2 = $Sprite2D.get_rect()
	region.position += position
	if Globals.WORLD_BOUNDARY.intersects(region):
		velocity = direction * speed
		move_and_slide()
	else:
		queue_free()

func _on_player_hit(body):
	# hit player and despawn
	body.hit_player(direction)
	queue_free()

func _on_building_collision(_body):
	# despawn
	queue_free()
