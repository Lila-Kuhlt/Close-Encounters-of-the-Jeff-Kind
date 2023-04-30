extends Node2D

const Arrow = preload("res://scenes/UI/Arrow.tscn")

var destination: Node2D
var arrow
var blue_arrow

## Starts the timer with `time_sec` seconds and connects the callback to the `timeout` signal.
func start_timer(time_sec: float, collectible: Globals.Collectible, callback: Callable):
	get_tree().create_timer(time_sec).timeout.connect(callback)

func pick_up():
	visible = false
	blue_arrow.queue_free()
	$PlayerDetector.set_deferred("monitoring", false)
	arrow = Arrow.instantiate()
	arrow.destination = destination
	get_parent().get_node("UI").add_child(arrow)

func _on_player_detected(player):
	player.collect_package(self)

func do_free() -> void:
	if is_instance_valid(arrow):
		arrow.queue_free()
	if is_instance_valid(blue_arrow):
		blue_arrow.queue_free()
	queue_free()
