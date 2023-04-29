extends Node2D

var destination: Vector2i

## Starts the timer with `time_sec` seconds and connects the callback to the `timeout` signal.
func start_timer(time_sec: float, callback: Callable):
	get_tree().create_timer(time_sec).timeout.connect(callback)

func pick_up():
	visible = false
	$Area2D.set_deferred("monitoring", false)

func _on_area_2d_body_entered(player):
	player.collect_package(self)
