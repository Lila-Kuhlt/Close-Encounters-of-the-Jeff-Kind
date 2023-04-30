@tool
extends Sprite2D

@export var collectible: Globals.Collectible: set = set_collectible
func set_collectible(v: Globals.Collectible):
	collectible = v
	frame = collectible
