extends Node

const DEBUG: bool = false

var WORLD_BOUNDARY: Rect2
var NO_TUTORIAL: bool = false

enum Collectible {
	MEDI_PACK, WEAPON, ALIEN_MEAT
}

func get_random_collectible() -> Collectible:
	return Collectible.values()[randi() % Collectible.size()]

func quit_game():
	get_tree().quit(0)
