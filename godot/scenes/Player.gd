extends CharacterBody2D

const Package = preload("res://scenes/Package.tscn")
const Bullet = preload("res://scenes/bullets/PointBullet.tscn")

const SPEED: float = 80.0
const MAX_QUEUE_SIZE: int = 5
const MAX_LIFES: int = 3
const KNOCKBACK_STRENGTH: float = 2
const KNOCKBACK_ENVELOPE: float = 0.86

var package_queue := []
var lifes := MAX_LIFES
var packages_delivered := 0
var is_stunned := false
var is_invincible := false
var knockback := Vector2(0, 0)

func _ready():
	get_parent().get_node("UI").set_max_health(MAX_LIFES)

## Tries to add a package to the queue and returns wether the package could be added.
func collect_package(package) -> bool:
	if package_queue.size() < MAX_QUEUE_SIZE:
		package_queue.append(package)
		package.pick_up()
		return true
	else:
		return false

## Removes a package from the queue and removes the node.
func remove_package(package):
	package_queue.erase(package)
	package.do_free()

## This function is called when a package timer reaches 0.
func _on_package_timeout(package):
	# check if package was already delivered
	if is_instance_valid(package):
		remove_package(package)
		lifes = max(lifes - 1, 0)
		if lifes == 0:
			get_parent().get_node("UI").trigger_game_over(packages_delivered)
		get_parent().get_node("UI").set_health(lifes)

func _on_destination_detector_area_entered(area):
	var dest = area.get_parent()
	var delivered_packages := []
	for package in package_queue:
		if package.destination == dest:
			delivered_packages.append(package)
	for package in delivered_packages:
		remove_package(package)
		packages_delivered += 1

func _physics_process(_delta):
	var direction := Input.get_vector("left", "right", "up", "down")
	if is_stunned:
		direction = Vector2(0, 0)
	direction += knockback
	knockback *= KNOCKBACK_ENVELOPE
	if direction.x > 0:
		$Character.scale = Vector2i(-1, 1)
	elif direction.x < 0:
		$Character.scale = Vector2i(1, 1)

	velocity = direction * SPEED
	move_and_slide()

	get_parent().get_node('Camera').position = position

func hit_player(direction: Vector2):
	if not is_invincible:
		knockback = direction.normalized() * KNOCKBACK_STRENGTH
	if is_stunned or is_invincible:
		return
	is_stunned = true
	$AnimationPlayer.play("hit")
	$StunTimer.start()

func _on_stun_timer_timeout() -> void:
	is_invincible = true
	is_stunned = false
	$AnimationPlayer.stop()
	$AnimationPlayer.play("invincible")
	$InvincibilityTimer.start()

func _on_invincibility_timer_timeout() -> void:
	$AnimationPlayer.stop()
	is_invincible = false
