extends CharacterBody2D

const Package = preload("res://scenes/Package.tscn")
const Bullet = preload("res://scenes/bullets/Point.Bullet.tscn")

const SPEED: float = 80.0
const MAX_QUEUE_SIZE: int = 5
const MAX_LIFES: int = 3

var package_queue := []
var lifes := MAX_LIFES
var packages_delivered := 0

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
	if package != null:
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
	if direction.x > 0:
		$Character.scale = Vector2i(-1, 1)
	elif direction.x < 0:
		$Character.scale = Vector2i(1, 1)

	velocity = direction * SPEED
	move_and_slide()

	get_parent().get_node('Camera').position = position
