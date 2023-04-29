extends CharacterBody2D

const Package = preload("res://scenes/Package.tscn")
const Bullet = preload("res://scenes/bullets/Point.Bullet.tscn")

const SPEED: float = 300.0
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
	remove_package(package)
	missed_packages += 1

func _physics_process(_delta):
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()

	# wrap position
	var screen_size := get_viewport_rect().size
	position.x = fposmod(position.x, screen_size.x)
	position.y = fposmod(position.y, screen_size.y)

var tmp_t := 0.0

func _process(delta: float) -> void:
	tmp_t += delta
	if Input.is_action_just_pressed("shoot"):
		var bullet = Bullet.instantiate()
		bullet.position = position
		bullet.vel = Vector2(sin(tmp_t), cos(tmp_t)) * 100.0
		get_parent().add_child(bullet)
