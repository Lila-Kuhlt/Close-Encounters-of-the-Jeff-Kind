extends Node2D

func _ready():
	pass

## Starts the timer with `time_sec` seconds and connects the callback to the `timeout` signal.
func start_timer(time_sec: float, callback: Callable):
	get_tree().create_timer(time_sec).timeout.connect(callback)
