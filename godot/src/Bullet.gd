extends CharacterBody2D

const Globals = preload("res://src/Globals.gd")
@export var SPEED = 30

var direction: Vector2

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED
	position += velocity * delta
	if (position.x > Globals.LOWER_RIGHT.x or position.y > Globals.LOWER_RIGHT.y
			or position.x < Globals.UPPER_LEFT.x or position.y < Globals.UPPER_LEFT.y):
		queue_free()
	else:
		move_and_slide()


func _on_hit_box_area_entered(_area):
	get_parent().get_node("Jeff").hit_player()
	queue_free()
