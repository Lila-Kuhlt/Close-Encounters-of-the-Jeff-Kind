extends CharacterBody2D

const Package = preload("res://scenes/Package.tscn")
const Bullet = preload("res://scenes/bullets/Point.Bullet.tscn")

const SPEED: float = 80.0
const MAX_QUEUE_SIZE: int = 5

var package_queue := []
var missed_packages := 0

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
	package.queue_free()

## This function is called when a package timer reaches 0.
func _on_package_timeout(package):
	# check if package was already delivered
	if package != null:
		remove_package(package)
		missed_packages += 1

func _on_destination_detector_area_entered(area):
	var dest = area.get_parent()
	var packages_to_be_removed := []
	for package in package_queue:
		if package.destination == dest:
			packages_to_be_removed.append(package)
	for package in packages_to_be_removed:
		remove_package(package)

func _physics_process(_delta):
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()

	# wrap position
	var screen_size := get_viewport_rect().size
	position.x = fposmod(position.x, screen_size.x)
	position.y = fposmod(position.y, screen_size.y)
