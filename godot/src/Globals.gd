extends Node

const DEBUG: bool = true

const UPPER_LEFT := Vector2(0.0, 0.0)
const LOWER_RIGHT := Vector2(2000.0, 1500.0)

enum Collectible {
	MEDI_PACK, WEAPON, ALIEN_MEAT
}

func get_random_collectible() -> Collectible:
	return Collectible.values()[randi() % Collectible.size()]
