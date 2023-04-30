extends Node2D

const Arrow = preload("res://scenes/UI/Arrow.tscn")

var destination: Node2D
var arrow;

## Starts the timer with `time_sec` seconds and connects the callback to the `timeout` signal.
func start_timer(time_sec: float, callback: Callable):
	get_tree().create_timer(time_sec).timeout.connect(callback)

func pick_up():
	visible = false
	$PlayerDetector.set_deferred("monitoring", false)
	arrow = Arrow.instantiate()
	arrow.destination = destination
	get_parent().get_node("UI").add_child(arrow)

func _on_player_detected(player):
	player.collect_package(self)

func do_free() -> void:
	if arrow:
		arrow.queue_free()
	queue_free()
