extends Node2D

var destination: Node2D

## Starts the timer with `time_sec` seconds and connects the callback to the `timeout` signal.
func start_timer(time_sec: float, callback: Callable):
	get_tree().create_timer(time_sec).timeout.connect(callback)

func pick_up():
	visible = false
	$PlayerDetector.set_deferred("monitoring", false)

func _on_player_detected(player):
	player.collect_package(self)
