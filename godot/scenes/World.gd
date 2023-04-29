extends Node2D

const Package = preload("res://scenes/Package.tscn")

const PACKAGE_SPAWN_AREA_ATLAS_COORDS := Vector2i(2, 2)

var rng := RandomNumberGenerator.new()
var package_spawn_areas := []

func _ready():
	populate_package_spawn_areas()

func populate_package_spawn_areas():
	var ground: TileMap = get_node('GroundTileMap')
	var areas := ground.get_used_cells_by_id(0, 1, PACKAGE_SPAWN_AREA_ATLAS_COORDS)
	for area in areas:
		package_spawn_areas.append(ground.map_to_local(area))

func build_package():
	var package: Node2D = Package.instantiate()
	add_child(package)
	var idx := rng.randi_range(0, len(package_spawn_areas))
	package.position = package_spawn_areas[idx]
	package.start_timer(2.0, $Player._on_package_timeout.bind(package))
	return package
