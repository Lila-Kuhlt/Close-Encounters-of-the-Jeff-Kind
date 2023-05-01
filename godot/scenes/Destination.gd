@tool
extends Node2D

var awaiting_packages := []

func _ready():
	$AnimationPlayer.play("idle")

func add_awaiting_package(package):
	if awaiting_packages.is_empty():
		$TextureSpeechBubble/IconCollectible.collectible = package.collectible
		$TextureSpeechBubble.show()
		$AnimationPlayer.play("idle")
	awaiting_packages.append(package)

func remove_awaiting_package(package):
	print(awaiting_packages)
	awaiting_packages.erase(package)
	print(awaiting_packages)
	if awaiting_packages.is_empty():
		$TextureSpeechBubble.hide()
		$AnimationPlayer.stop()
