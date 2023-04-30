@tool
extends Node2D

@export var collectible: Globals.Collectible: set = set_collectible
func set_collectible(v: Globals.Collectible):
	collectible = v
	$TextureSpeechBubble/IconCollectible.collectible = collectible
	
func _ready():
	set_collectible(collectible)
	$AnimationPlayer.play("idle")
