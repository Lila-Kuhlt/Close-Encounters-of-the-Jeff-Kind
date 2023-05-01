extends CharacterBody2D

const Package = preload("res://scenes/Package.tscn")
const Bullet = preload("res://scenes/bullets/PointBullet.tscn")

const SPEED: float = 120.0 if Globals.DEBUG else 90.0
const MAX_QUEUE_SIZE: int = 5
const MAX_LIFES: int = 20 if Globals.DEBUG else 3
const KNOCKBACK_STRENGTH: float = 2
const KNOCKBACK_ENVELOPE: float = 0.86
const DASH_FACTOR := 4.0

@onready var UI = get_parent().get_node("UI")

var package_queue := []
var lifes := MAX_LIFES
var packages_delivered := 0
var is_stunned := false
var is_invincible := false
var can_dash := true
var dashing := false
var knockback := Vector2(0, 0)

@onready var cam: Camera2D = get_parent().get_node('Camera')
@onready var jeff_tex: Texture2D = load("res://assets/Jeff.png")
@onready var keff_tex: Texture2D = load("res://assets/Keff.png")

func _ready():
	UI.set_max_health(MAX_LIFES)
	UI.set_score(packages_delivered)

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
	if is_instance_valid(package) and package != null:
		remove_package(package)
		lifes = max(lifes - 1, 0)
		if lifes == 0:
			UI.trigger_game_over(packages_delivered)
		UI.set_health(lifes)

func _on_destination_detector_area_entered(area):
	var dest = area.get_parent()
	var delivered_packages := []
	for package in package_queue:
		if package.destination == dest:
			delivered_packages.append(package)
	for package in delivered_packages:
		remove_package(package)
		packages_delivered += 1
		UI.set_score(packages_delivered)

func _physics_process(_delta):
	position = position.clamp(Globals.WORLD_BOUNDARY.position, Globals.WORLD_BOUNDARY.end)
	var direction := Input.get_vector("left", "right", "up", "down")
	var has_input := direction.x != 0 or direction.y != 0
	if Input.is_action_just_pressed("dash") and can_dash and (not is_stunned or Globals.DEBUG):
		can_dash = false
		$DashCooldownTimer.start()
		$DashTimer.start()
		dashing = true
		$HitBox/CollisionShape2D.disabled = true
		$Character.texture = keff_tex
		$GPUParticles2D.restart()
		$DustFadeAnimationPlayer.play('fade')
		$DashSoundPlayer.play()
	if dashing:
		if not has_input:
			direction = Vector2(1 if $Character.scale.x < 0 else -1, 0)
		direction *= DASH_FACTOR
	if is_stunned and not Globals.DEBUG:
		direction = Vector2(0, 0)
	if direction.x > 0:
		$Character.scale = Vector2i(-1, 1)
	elif direction.x < 0:
		$Character.scale = Vector2i(1, 1)
	direction += knockback
	knockback *= KNOCKBACK_ENVELOPE

	velocity = direction * SPEED
	var collided := move_and_slide()
	$WalkAnimationPlayer.play('walk' if has_input and not collided else 'idle')

	var vp := get_viewport()
	var off := 0.5 * vp.get_visible_rect().size / vp.get_camera_2d().zoom
	cam.position = position.clamp(
		Globals.WORLD_BOUNDARY.position + off,
		Globals.WORLD_BOUNDARY.end - off)

func hit_player(direction: Vector2):
	$HitSoundPlayer.play()
	if not is_invincible:
		knockback = direction.normalized() * KNOCKBACK_STRENGTH
	if is_stunned or is_invincible:
		return
	is_stunned = true
	$HitAnimationPlayer.play("hit")
	$StunTimer.start()

func _on_stun_timer_timeout() -> void:
	is_invincible = true
	is_stunned = false
	$HitAnimationPlayer.stop()
	$HitAnimationPlayer.play("invincible")
	$InvincibilityTimer.start()

func _on_invincibility_timer_timeout() -> void:
	$HitAnimationPlayer.stop()
	is_invincible = false

func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	$Character.texture = jeff_tex

func _on_dash_timer_timeout() -> void:
	dashing = false
	$HitBox/CollisionShape2D.disabled = false
