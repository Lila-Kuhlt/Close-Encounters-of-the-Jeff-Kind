extends Node

const DEBUG: bool = true

var WORLD_BOUNDARY: Rect2

func _ready():
	var boundary = get_tree().get_first_node_in_group("Boundary")
	WORLD_BOUNDARY = Rect2(boundary.position, boundary.size)

enum Collectible {
	MEDI_PACK, WEAPON, ALIEN_MEAT
}

func get_random_collectible() -> Collectible:
	return Collectible.values()[randi() % Collectible.size()]
