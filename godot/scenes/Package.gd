@tool
extends Node2D

const Arrow = preload("res://scenes/UI/Arrow.tscn")
const RadialProgressBar = preload("res://scenes/UI/RadialProgressBar.tscn")

var destination: Node2D
var arrow: CanvasLayer
var blue_arrow: CanvasLayer
var progress_bar: Node2D

@export var collectible: Globals.Collectible: set = set_collectible
func set_collectible(v: Globals.Collectible):
	collectible = v
	$SpritePackage/IconCollectible.collectible = collectible

func _ready():
	set_collectible(collectible)
	$AnimationPlayer.play("idle")

## Starts the timer with `time_sec` seconds and connects the callback to the `timeout` signal.
func start_timer(time_start: float, time: float, callback: Callable):
	progress_bar = RadialProgressBar.instantiate()
	progress_bar.value_max = time
	progress_bar.value = time - time_start
	progress_bar.visible = true
	blue_arrow.progress_bar = progress_bar
	get_parent().get_node("UI").add_child(progress_bar)

	var tween := get_tree().create_tween()
	tween.tween_property(progress_bar, "value", 0, time - time_start)
	tween.tween_callback(callback)

func pick_up():
	visible = false
	blue_arrow.queue_free()
	$PlayerDetector.set_deferred("monitoring", false)

	arrow = Arrow.instantiate()
	arrow.destination = destination
	arrow.progress_bar = progress_bar
	get_parent().get_node("UI").add_child(arrow)

func _on_player_detected(player):
	player.collect_package(self)

func do_free() -> void:
	destination.remove_awaiting_package(self)
	if is_instance_valid(arrow):
		arrow.queue_free()
	if is_instance_valid(blue_arrow):
		blue_arrow.queue_free()
	progress_bar.queue_free()
	queue_free()
